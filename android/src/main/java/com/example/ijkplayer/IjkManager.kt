package com.example.ijkplayer

/// create 2019/3/7 by cai


import io.flutter.plugin.common.PluginRegistry
import java.util.*

class IjkManager(private val registrar: PluginRegistry.Registrar) {
    private val ijkList = ArrayList<Ijk>()

    fun create(): Ijk {
        val ijk = Ijk(registrar)
        ijkList.add(ijk)
        return ijk
    }

    fun findIJK(id: Long): Ijk? {
        return ijkList.find { it.id == id }
    }

    fun dispose(id: Long) {
        val ijk = findIJK(id) ?: return
        ijkList.remove(ijk)
        ijk.dispose()
    }
}