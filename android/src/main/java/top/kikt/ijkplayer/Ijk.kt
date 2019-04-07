package top.kikt.ijkplayer

/// create 2019/3/7 by cai


import android.graphics.Bitmap
import android.util.Base64
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import top.kikt.ijkplayer.entity.Info
import tv.danmaku.ijk.media.player.IjkMediaPlayer
import tv.danmaku.ijk.media.player.TextureMediaPlayer
import java.io.ByteArrayOutputStream
import java.io.File

class Ijk(private val registry: PluginRegistry.Registrar) : MethodChannel.MethodCallHandler {

    private val textureEntry = registry.textures().createSurfaceTexture()
    val id: Long
        get() = textureEntry.id()

    val mediaPlayer: IjkMediaPlayer = IjkMediaPlayer()
    private val textureMediaPlayer: TextureMediaPlayer

    private val methodChannel: MethodChannel = MethodChannel(registry.messenger(), "top.kikt/ijkplayer/$id")

    private val notifyChannel: NotifyChannel = NotifyChannel(registry, id, this)

    var degree = 0

    init {
        textureMediaPlayer = TextureMediaPlayer(mediaPlayer)
        configOptions()
        textureMediaPlayer.surfaceTexture = textureEntry.surfaceTexture()
        methodChannel.setMethodCallHandler(this)
    }

    private fun configOptions() {
        // see https://www.jianshu.com/p/843c86a9e9ad
        mediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "fflags", "fastseek")
        mediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "analyzemaxduration", 100L)
        mediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "analyzeduration", 1)
        mediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "probesize", 1024 * 10)
        mediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "flush_packets", 1L)
        mediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "reconnect", 5)
        mediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "framedrop", 5)
        mediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "enable-accurate-seek", 1)
        mediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "mediacodec", 1) // 开硬解

        //        mediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "max-buffer-size", maxCacheSize)
        //        mediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "packet-buffering", if (isBufferCache) 1 else 0)
    }

    override fun onMethodCall(call: MethodCall?, result: MethodChannel.Result?) {
        when (call?.method) {
            "setNetworkDataSource" -> {
                val uri = call.argument<String>("uri")
                val params = call.argument<Map<String, String>>("headers")
                if (uri == null) {
                    handleSetUriResult(Exception("uri是必传参数"), result)
                    return
                }
                setUri(uri, params) { throwable ->
                    handleSetUriResult(throwable, result)
                }
            }
            "setAssetDataSource" -> {
                val name = call.argument<String>("name")
                val `package` = call.argument<String>("package")
                if (name != null) {
                    setAssetUri(name, `package`) { throwable ->
                        handleSetUriResult(throwable, result)
                    }
                } else {
                    handleSetUriResult(Exception("没有找到资源"), result)
                }
            }
            "setFileDataSource" -> {
                val path = call.argument<String>("path")
                if (path != null) {
                    setUri("file://$path", hashMapOf()) { throwable ->
                        handleSetUriResult(throwable, result)
                    }
                }
            }
            "play" -> {
                play()
                result?.success(true)
            }
            "pause" -> {
                pause()
                result?.success(true)
            }
            "stop" -> {
                stop()
                result?.success(true)
            }
            "getInfo" -> {
                val info = getInfo()
                result?.success(info.toMap())
            }
            "seekTo" -> {
                val target = call.argument<Double>("target")
                if (target != null) {
                    seekTo((target * 1000).toLong())
                }
                result?.success(true)
            }
            "setVolume" -> {
                val volume = call.argument<Int>("volume")
                setVolume(volume)
                result?.success(true)
            }
            "getVolume" -> {
//                result?.success(this.mediaPlayer.setVolume())
            }
            "screenShot" -> {
                val bytes = screenShot()
                result?.success(bytes)
            }
            else -> {
                result?.notImplemented()
            }
        }
    }

    private fun screenShot(): ByteArray? {
        val frameBitmap = mediaPlayer.frameBitmap
        return if (frameBitmap != null) {
            val outputStream = ByteArrayOutputStream()
            frameBitmap.compress(Bitmap.CompressFormat.JPEG, 100, outputStream)
            frameBitmap.recycle()
            outputStream.toByteArray()
        } else {
            null
        }
    }

    fun getInfo(): Info {
        val duration = mediaPlayer.duration
        val currentPosition = mediaPlayer.currentPosition
        val width = mediaPlayer.videoWidth
        val height = mediaPlayer.videoHeight
        val outputFps = mediaPlayer.videoOutputFramesPerSecond
//        mediaPlayer.mediaInfo.mAudioDecoder
//        mediaPlayer.mediaInfo.mVideoDecoder
        return Info(
                duration = duration.toDouble() / 1000,
                currentPosition = currentPosition.toDouble() / 1000,
                width = width,
                height = height,
                isPlaying = textureMediaPlayer.isPlaying,
                degree = degree,
                tcpSpeed = mediaPlayer.tcpSpeed,
                outputFps = outputFps
//                decodeFps = mediaPlayer.videoDecodeFramesPerSecond
        )
    }

    private fun handleSetUriResult(throwable: Throwable?, result: MethodChannel.Result?) {
        if (throwable == null) {
            result?.success(true)
        } else {
            throwable.printStackTrace()
            result?.error("1", "设置资源失败", throwable)
        }
    }

    private fun setUri(uri: String, headers: Map<String, String>?, callback: (Throwable?) -> Unit) {
        try {
//            mediaPlayer.dataSource = uri
            mediaPlayer.setDataSource(uri, headers)
            mediaPlayer.prepareAsync()
            callback(null)
        } catch (e: Exception) {
            e.printStackTrace()
            callback(e)
        }
    }

    private fun setAssetUri(name: String, `package`: String?, callback: (Throwable?) -> Unit) {
        try {
            mediaPlayer.setOnPreparedListener {
                callback(null)
            }
            val asset =
                    if (`package` == null) {
                        registry.lookupKeyForAsset(name)
                    } else {
                        registry.lookupKeyForAsset(name, `package`)
                    }
            val assetManager = registry.context().assets
            val fd = assetManager.openFd(asset)
            val cacheDir = registry.context().cacheDir.absoluteFile.path

            val fileName = Base64.encodeToString(asset.toByteArray(), Base64.DEFAULT)
            val file = File(cacheDir, fileName)
            fd.createInputStream().copyTo(file.outputStream())
            mediaPlayer.dataSource = file.path
//            ijkPlayer.setDataSource(fd.fileDescriptor) // can't use,
            mediaPlayer.prepareAsync()
        } catch (e: Exception) {
            e.printStackTrace()
            callback(e)
        }
    }

    fun dispose() {
        notifyChannel.dispose()
        methodChannel.setMethodCallHandler(null)
        textureMediaPlayer.stop()
        textureMediaPlayer.release()
        textureEntry.release()
    }

    private fun play() {
        try {
            mediaPlayer.start()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun pause() {
        textureMediaPlayer.pause()
    }

    private fun stop() {
        textureMediaPlayer.stop()
    }

    private fun seekTo(msec: Long) {
        textureMediaPlayer.seekTo(msec)
    }

    private fun setVolume(volume: Int?) {
        if (volume == null) {
            return
        }
        val v = volume.toFloat() / 100
        mediaPlayer.setVolume(v, v)
    }

}

