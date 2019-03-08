package com.example.ijkplayer

/// create 2019/3/7 by cai


import io.flutter.plugin.common.PluginRegistry
import tv.danmaku.ijk.media.player.IjkMediaPlayer
import tv.danmaku.ijk.media.player.TextureMediaPlayer
import java.util.concurrent.Executors

class IJK(private val registry: PluginRegistry.Registrar) {
    private val textureEntry = registry.textures().createSurfaceTexture()
    private val threadPool = Executors.newCachedThreadPool()
    val id: Long
        get() = textureEntry.id()

    private val ijkPlayer: IjkMediaPlayer = IjkMediaPlayer()
    private val mediaPlayer: TextureMediaPlayer

    init {
        mediaPlayer = TextureMediaPlayer(ijkPlayer)
        mediaPlayer.surfaceTexture = textureEntry.surfaceTexture()
    }

    fun setUri(uri: String, callback: (Throwable?) -> Unit) {
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

    fun dispose() {
        mediaPlayer.stop()
        mediaPlayer.release()
        textureEntry.release()
    }

    fun play() {
        try {
            mediaPlayer.start()
//            ijkPlayer.start()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun pause() {
        mediaPlayer.pause()
    }

    fun stop() {
        mediaPlayer.stop()
    }

    fun reset() {
        mediaPlayer.reset()
    }

    fun seekTo(msec: Long) {
        mediaPlayer.seekTo(msec)
    }

    fun getDuration(): Long {
        return mediaPlayer.duration
    }

}

