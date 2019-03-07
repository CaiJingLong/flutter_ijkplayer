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

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "create" -> {
                try {
                    val ijk = manager.create()
                    result.success(ijk.id)
                } catch (e: Exception) {
                    result.error("error", "创建失败", null)
                }
            }
            "dispose" -> {
                val id = call.arguments<Long>()
                manager.dispose(id)
            }
            "setData" -> {
                val id = call.argument<Int>("id")!!
                val uri = call.argument<String>("uri")!!
                manager.findIJK(id.toLong())?.setUri(uri) {
                    result.success(1)
                }
            }
            "setNetData" -> {
                val id = call.argument<Int>("id")!!
                val uri = call.argument<String>("uri")!!
                manager.findIJK(id.toLong())?.setNetUri(uri) {
                    result.success(1)
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
