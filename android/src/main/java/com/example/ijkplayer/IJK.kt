package com.example.ijkplayer

/// create 2019/3/7 by cai


import android.net.Uri
import io.flutter.plugin.common.PluginRegistry
import tv.danmaku.ijk.media.player.IjkMediaPlayer
import tv.danmaku.ijk.media.player.TextureMediaPlayer

class IJK(private val registry: PluginRegistry.Registrar) {
    private val textureEntry = registry.textures().createSurfaceTexture()

    val id: Long
        get() = textureEntry.id()

    private val ijkPlayer: IjkMediaPlayer = IjkMediaPlayer()
    private val mediaPlayer: TextureMediaPlayer

    init {
        mediaPlayer = TextureMediaPlayer(ijkPlayer)
        mediaPlayer.surfaceTexture = textureEntry.surfaceTexture()
    }

    fun setUri(uri: String, callback: () -> Unit) {
        mediaPlayer.setDataSource(registry.activeContext(), Uri.parse(uri))
        mediaPlayer.setOnPreparedListener {
            callback()
        }
    }

    fun setNetUri(uri: String, callback: () -> Unit) {
        try {
            ijkPlayer.setOnPreparedListener {
                callback()
            }
            ijkPlayer.dataSource = uri
            ijkPlayer.prepareAsync()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun dispose() {
        mediaPlayer.releaseSurfaceTexture()
        mediaPlayer.release()
        ijkPlayer.release()
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

    fun seekTo(msec: Long) {
        mediaPlayer.seekTo(msec)
    }

    fun getDuration(): Long {
        return mediaPlayer.duration
    }

}

