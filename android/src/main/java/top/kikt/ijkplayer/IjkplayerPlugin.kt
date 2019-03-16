package top.kikt.ijkplayer

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
            else -> result.notImplemented()
        }
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
