package com.example.ijkplayer

/// create 2019/3/7 by cai


import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import tv.danmaku.ijk.media.player.IjkMediaPlayer
import tv.danmaku.ijk.media.player.TextureMediaPlayer

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
            "setDataSource" -> {
                val uri = call.argument<String>("uri")!!
                setUri(uri) { throwable ->
                    if (throwable == null) {
                        result?.success(throwable)
                    } else {
                        throwable.printStackTrace()
                        result?.error("2", "加载失败", throwable)
                    }
                }
            }
            "setAssetDataSource" -> {

                val uri = call.argument<String>("uri")!!
                setUri(uri) { throwable ->
                    if (throwable == null) {
                        result?.success(throwable)
                    } else {
                        throwable.printStackTrace()
                        result?.error("2", "加载失败", throwable)
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

            // 设置资产系的datasource


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

