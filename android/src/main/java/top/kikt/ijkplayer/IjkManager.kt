package top.kikt.ijkplayer

/// create 2019/3/7 by cai


import io.flutter.plugin.common.PluginRegistry
import java.util.*

class IjkManager(private val registrar: PluginRegistry.Registrar) {
    private val ijkList = ArrayList<Ijk>()

    fun create(options: Map<String, Any>): Ijk {
        val ijk = Ijk(registrar,options)
        ijkList.add(ijk)
        return ijk
    }

    private fun findIJK(id: Long): Ijk? {
        return ijkList.find { it.id == id }
    }

    fun dispose(id: Long) {
        val ijk = findIJK(id) ?: return
        ijkList.remove(ijk)
        ijk.dispose()
    }

    fun disposeAll() {
        for (ijk in ijkList.toList()) {
            ijkList.remove(ijk)
            ijk.dispose()
        }
    }
}