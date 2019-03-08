package com.example.ijkplayer

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/**
 * IjkplayerPlugin
 */
class IjkplayerPlugin(private val registrar: Registrar) : MethodCallHandler {

    private val manager: IjkManager = IjkManager(registrar)
    //    private val threadPool = Executors.newScheduledThreadPool(10)
//    private val handler = Handler(Looper.getMainLooper())
//
//    private inline fun runOnMainThread(crossinline runnable: () -> Unit) {
//        handler.post {
//            runnable()
//        }
//    }

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
                    result.error("1", "创建失败", e)
                }
            }
            "dispose" -> {
                val id = call.getLongArg()
                manager.dispose(id)
            }
            "setDataSource" -> {
                val id = call.argument<Int>("id")!!
                val uri = call.argument<String>("uri")!!
                manager.findIJK(id.toLong())?.setUri(uri) { throwable ->
                    if (throwable == null) {
                        result.success(throwable)
                    } else {
                        throwable.printStackTrace()
                        result.error("2", "加载失败", throwable)
                    }
                }
            }
            "play" -> {
                val id = call.arguments<Int>()
                manager.findIJK(id.toLong())?.play()
                result.success(1)
            }
            "pause" -> {
                val id = call.arguments<Int>()
                manager.findIJK(id.toLong())?.pause()
            }
            "stop" -> {
                val id = call.arguments<Int>()
                manager.findIJK(id.toLong())?.stop()
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

        /**
         * Plugin registration.
         */
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "top.kikt/ijkplayer")
            channel.setMethodCallHandler(IjkplayerPlugin(registrar))
        }
    }
}
