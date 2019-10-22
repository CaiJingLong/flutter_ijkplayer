package top.kikt.ijkplayer

import android.content.Context
import android.media.AudioManager
import android.view.WindowManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import tv.danmaku.ijk.media.player.IjkMediaPlayer


/**
 * IjkplayerPlugin
 */
class IjkplayerPlugin(private val registrar: Registrar) : MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: Result) {
        IjkMediaPlayer.loadLibrariesOnce(null)
        IjkMediaPlayer.native_profileBegin("libijkplayer.so")
        handleMethodCall(call, result)
    }

    private fun handleMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> {
                manager.disposeAll()
                result.success(true)
            }
            "create" -> {
                try {
                    val options: Map<String, Any> = call.arguments()
                    val ijk = manager.create(options)
                    result.success(ijk.id)
                } catch (e: Exception) {
                    e.printStackTrace()
                    result.error("1", "创建失败", e)
                }
            }
            "dispose" -> {
                val id = call.argument<Int>("id")!!.toLong()
                manager.dispose(id)
                result.success(true)
            }
            "setSystemVolume" -> {
                val volume = call.argument<Int>("volume")
                if (volume != null) {
                    setVolume(volume)
                }
                result.success(true)
            }
            "getSystemVolume" -> {
                val volume = getSystemVolume()
                result.success(volume)
            }
            "volumeUp" -> {
                this.volumeUp()
                val volume = getSystemVolume()
                result.success(volume)
            }
            "volumeDown" -> {
                this.volumeDown()
                val volume = getSystemVolume()
                result.success(volume)
            }
            "setSystemBrightness" -> {
                val target = call.argument<Double>("brightness")
                if (target != null) setBrightness(target.toFloat())
                result.success(true)
            }
            "getSystemBrightness" -> {
                result.success(getBrightness().toDouble())
            }
            "resetBrightness" -> {
                setBrightness(WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE)
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    private fun getSystemVolume(): Int {
        val max = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC).toFloat()
        return (audioManager.getStreamVolume(AudioManager.STREAM_MUSIC).toFloat() / max * 100).toInt()
    }

    private fun setVolume(volume: Int) {
        audioManager.apply {
            val max = getStreamMaxVolume(AudioManager.STREAM_MUSIC)

            val step = 100.toFloat() / max.toFloat()

            val current = getSystemVolume()

            val progress = current * step

            if (volume > progress) {
                volumeDown()
            } else if (volume < progress) {
                volumeUp()
            }
        }
    }

    private fun volumeUp() {
        audioManager.adjustStreamVolume(AudioManager.STREAM_MUSIC, AudioManager.ADJUST_RAISE, AudioManager.FLAG_PLAY_SOUND)
    }

    private fun volumeDown() {
        audioManager.adjustStreamVolume(AudioManager.STREAM_MUSIC, AudioManager.ADJUST_LOWER, AudioManager.FLAG_PLAY_SOUND)
    }

    private val audioManager: AudioManager
        get() = registrar.activity().getSystemService(Context.AUDIO_SERVICE) as AudioManager

    private fun setBrightness(brightness: Float) {
        val window = registrar.activity().window
        val lp = window.attributes
        lp.screenBrightness = brightness
        window.attributes = lp
    }

    private fun getBrightness(): Float {
        val window = registrar.activity().window
        val lp = window.attributes
        return lp.screenBrightness
    }

    fun MethodCall.getLongArg(key: String): Long {
        return this.argument<Int>(key)!!.toLong()
    }

    fun MethodCall.getLongArg(): Long {
        return this.arguments<Int>().toLong()
    }

    companion object {
        lateinit var manager: IjkManager

        /**
         * Plugin registration.
         */
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "top.kikt/ijkplayer")
            channel.setMethodCallHandler(IjkplayerPlugin(registrar))
            manager = IjkManager(registrar)
        }
    }
}
