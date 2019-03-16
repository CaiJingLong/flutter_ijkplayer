package top.kikt.ijkplayer

/// create 2019/3/7 by cai


import android.util.Base64
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import top.kikt.ijkplayer.entity.Info
import tv.danmaku.ijk.media.player.IjkMediaPlayer
import tv.danmaku.ijk.media.player.TextureMediaPlayer
import java.io.File

class Ijk(private val registry: PluginRegistry.Registrar) : MethodChannel.MethodCallHandler {

    private val textureEntry = registry.textures().createSurfaceTexture()
    val id: Long
        get() = textureEntry.id()

    val ijkPlayer: IjkMediaPlayer = IjkMediaPlayer()
    private val mediaPlayer: TextureMediaPlayer

    private val methodChannel: MethodChannel = MethodChannel(registry.messenger(), "top.kikt/ijkplayer/$id")

    private val notifyChannel: NotifyChannel = NotifyChannel(registry, id, this)

    init {
        mediaPlayer = TextureMediaPlayer(ijkPlayer)
        mediaPlayer.surfaceTexture = textureEntry.surfaceTexture()
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall?, result: MethodChannel.Result?) {
        when (call?.method) {
            "setNetworkDataSource" -> {
                val uri = call.argument<String>("uri")
                if (uri == null) {
                    handleSetUriResult(Exception("uri是必传参数"), result)
                    return
                }
                setUri(uri) { throwable ->
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
                    setUri("file://$path") { throwable ->
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
            else -> {
                result?.notImplemented()
            }
        }
    }

    fun getInfo(): Info {
        val duration = ijkPlayer.duration
        val currentPosition = ijkPlayer.currentPosition
        val width = ijkPlayer.videoWidth
        val height = ijkPlayer.videoHeight
        return Info(
                duration = duration.toDouble() / 1000,
                currentPosition = currentPosition.toDouble() / 1000,
                width = width,
                height = height,
                isPlaying = ijkPlayer.isPlaying
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

    private fun setUri(uri: String, callback: (Throwable?) -> Unit) {
        try {
            ijkPlayer.dataSource = uri
            ijkPlayer.prepareAsync()
            callback(null)
        } catch (e: Exception) {
            e.printStackTrace()
            callback(e)
        }
    }

    private fun setAssetUri(name: String, `package`: String?, callback: (Throwable?) -> Unit) {
        try {
            ijkPlayer.setOnPreparedListener {
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
            ijkPlayer.dataSource = file.path
//            ijkPlayer.setDataSource(fd.fileDescriptor) // can't use,
            ijkPlayer.prepareAsync()
        } catch (e: Exception) {
            e.printStackTrace()
            callback(e)
        }
    }

    fun dispose() {
        notifyChannel.dispose()
        methodChannel.setMethodCallHandler(null)
        mediaPlayer.stop()
        mediaPlayer.release()
        textureEntry.release()
    }

    private fun play() {
        try {
            ijkPlayer.start()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun pause() {
        mediaPlayer.pause()
    }

    private fun stop() {
        mediaPlayer.stop()
    }

    fun seekTo(msec: Long) {
        mediaPlayer.seekTo(msec)
    }

}

