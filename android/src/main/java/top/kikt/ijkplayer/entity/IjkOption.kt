package top.kikt.ijkplayer.entity

/// create 2019/4/12 by cai

class IjkOption(option: Map<*, *>) {

    lateinit var type: Type
    lateinit var key: String
    lateinit var value: Any

    var isInit = true

    init {
        val type = option["category"]
        if (type is Int) {
            this.type = convertIntToType(type)
        }

        val key = option["key"]
        if (key is String) {
            this.key = key
            isInit = isInit and true
        }

        option["value"]?.let {
            this.value = it
            isInit = isInit and true
        }

        isInit = (type is Int) and (key is String) and (option.containsKey("value"))
    }

    private fun convertIntToType(typeInt: Int): Type {
        return when (typeInt) {
            0 -> Type.Format
            1 -> Type.Codec
            2 -> Type.Sws
            3 -> Type.Player
            else -> Type.Other
        }
    }

    enum class Type {
        Format,
        Codec,
        Sws,
        Player,
        Other,
    }
}