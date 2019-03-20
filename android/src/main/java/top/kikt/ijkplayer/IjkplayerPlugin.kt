package top.kikt.ijkplayer

import android.content.Context
import android.media.AudioManager
import android.os.Build
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


/**
 * IjkplayerPlugin
 */
class IjkplayerPlugin(private val registrar: Registrar) : MethodCallHandler {


    override fun onMethodCall(call: MethodCall, result: Result) {
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
                    val ijk = manager.create()
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
            else -> result.notImplemented()
        }
    }

    private fun getSystemVolume(): Int {
        return audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)
    }

    private fun setVolume(volume: Int) {
        audioManager.apply {
            val max = getStreamMaxVolume(AudioManager.STREAM_MUSIC)
            val min = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                getStreamMinVolume(AudioManager.STREAM_MUSIC)
            } else {
                0
            }
            val diff: Float = (max - min).toFloat()
            val target: Int = ((min + diff) * volume).toInt()
            setStreamVolume(AudioManager.STREAM_MUSIC, target, 0)
        }
    }

    private val audioManager: AudioManager
        get() = registrar.activity().getSystemService(Context.AUDIO_SERVICE) as AudioManager

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
