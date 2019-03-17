package top.kikt.ijkplayer

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import tv.danmaku.ijk.media.player.IMediaPlayer

class NotifyChannel(val registry: PluginRegistry.Registrar, val textureId: Long, val ijk: Ijk) {

    private val player
        get() = ijk.ijkPlayer

    private val channel = MethodChannel(
            registry.messenger(),
            "top.kikt/ijkplayer/event/$textureId"
    )

    private val info
        get() = ijk.getInfo().toMap()

    init {
        player.setOnPreparedListener {
            logi("prepare $info")
            channel.invokeMethod("prepare", info)
        }
        player.setOnCompletionListener {
            logi("completion $info")
            channel.invokeMethod("completion", info)
        }
        player.setOnBufferingUpdateListener { mp, percent ->
            /// 在线视频缓冲
            logi("completion buffer update $info $percent")
        }
        player.setOnSeekCompleteListener {
            logi("onSeekCompletion $info")
        }
        player.setOnErrorListener { mp, what, extra ->
            channel.invokeMethod("error", what)
            logi("onError $what")
            false
        }
        player.setOnInfoListener { mp, what, extra ->
            logi("onInfoListener $what, extra = $extra, isPlaying = ${player.isPlaying} ")
            when (what) {
                IMediaPlayer.MEDIA_INFO_AUDIO_DECODED_START, IMediaPlayer.MEDIA_INFO_VIDEO_DECODED_START -> {
                    channel.invokeMethod("playStateChange", info)
                }
            }
            false
        }
        player.setOnNativeInvokeListener { what, args ->
            logi("onNativeInvoke $what")
            false
        }
        player.setOnControlMessageListener {
            logi("onController message $it, isPlaying = ${player.isPlaying}")
            ""
        }
    }

    fun dispose() {
        player.resetListeners()
    }

}