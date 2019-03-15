package com.example.ijkplayer

import android.content.res.AssetFileDescriptor
import tv.danmaku.ijk.media.player.misc.IMediaDataSource
import java.io.IOException
import java.io.InputStream


/// create 2019/3/15 by cai
///
/// copy from https://github.com/jadennn/flutter_ijk/blob/2cab57aca9548fde2274ff0651caae6ba36b210b/android/src/main/java/com/jaden/flutterijk/RawDataSourceProvider.java
class AssetDataSource(private val mDescriptor: AssetFileDescriptor) : IMediaDataSource {
    private var mMediaBytes: ByteArray? = null

    override fun readAt(position: Long, buffer: ByteArray, offset: Int, size: Int): Int {
        if (position + 1 >= mMediaBytes!!.size) {
            return -1
        }
        var length: Int
        if (position + size < mMediaBytes!!.size) {
            length = size
        } else {
            length = (mMediaBytes!!.size - position).toInt()
            if (length > buffer.size)
                length = buffer.size
            length--
        }
        // 把文件内容copy到buffer中；
        System.arraycopy(mMediaBytes!!, position.toInt(), buffer, offset, length)
        return length
    }

    @Throws(IOException::class)
    override fun getSize(): Long {
        val length = mDescriptor.length
        if (mMediaBytes == null) {
            val inputStream = mDescriptor.createInputStream()
            mMediaBytes = readBytes(inputStream)
        }
        return length
    }

    @Throws(IOException::class)
    override fun close() {
        mDescriptor.close()
        mMediaBytes = null
    }

    //读取文件内容
    @Throws(IOException::class)
    private fun readBytes(inputStream: InputStream): ByteArray {
        return inputStream.readBytes()
    }
}