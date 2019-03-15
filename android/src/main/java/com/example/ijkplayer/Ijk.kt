package com.example.ijkplayer

/// create 2019/3/7 by cai


import android.util.Base64
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import tv.danmaku.ijk.media.player.IjkMediaPlayer
import tv.danmaku.ijk.media.player.TextureMediaPlayer
import java.io.File

class Ijk(private val registry: PluginRegistry.Registrar) : MethodChannel.MethodCallHandler {

    private val textureEntry = registry.textures().createSurfaceTexture()
    val id: Long
        get() = textureEntry.id()

    private val ijkPlayer: IjkMediaPlayer = IjkMediaPlayer()
    private val mediaPlayer: TextureMediaPlayer

    private val methodChannel: MethodChannel = MethodChannel(registry.messenger(), "top.kikt/ijkplayer/$id")

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
                result?.success(1)
            }
            "pause" -> {
                pause()
            }
            "stop" -> {
                stop()
            }
            else -> {
                result?.notImplemented()
            }
        }
    }

    private fun handleSetUriResult(throwable: Throwable?, result: MethodChannel.Result?) {
        if (throwable == null) {
            result?.success(null)
        } else {
            throwable.printStackTrace()
            result?.error("1", "设置资源失败", throwable)
        }
    }

    private fun setUri(uri: String, callback: (Throwable?) -> Unit) {
        try {
            ijkPlayer.setOnPreparedListener {
                callback(null)
            }
            ijkPlayer.dataSource = uri
            ijkPlayer.prepareAsync()
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
        mediaPlayer.stop()
        mediaPlayer.release()
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
        mediaPlayer.pause()
    }

    private fun stop() {
        mediaPlayer.stop()
    }

    fun seekTo(msec: Long) {
        mediaPlayer.seekTo(msec)
    }

    fun getDuration(): Long {
        return mediaPlayer.duration
    }

}

