package top.kikt.ijkplayer.entity

/// create 2019/3/15 by cai
data class Info(
        val duration: Double,
        val currentPosition: Double,
        val width: Int,
        val height: Int,
        val isPlaying: Boolean,
        val degree: Int = 0,
        val tcpSpeed: Long = 0,
        val outputFps: Float = 0f
//        val decodeFps: Float = 0f
) {

    fun toMap(): Map<String, Any> {
        val map = HashMap<String, Any>()
        map["duration"] = duration
        map["currentPosition"] = currentPosition
        map["width"] = width
        map["height"] = height
        map["isPlaying"] = isPlaying
        map["degree"] = degree
        map["tcpSpeed"] = tcpSpeed
        map["outputFps"] = outputFps
//        map["decodeFps"] = decodeFps
        return map
    }

}