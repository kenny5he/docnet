

非池化:
    例: ByteBuf
池化:

堆外内存:
    最终写出去的Buffer全都是堆外内存
堆内内存:
    堆内内存性能更快，堆内内存在JVM内


ChannelInBoundHandler 入栈(读)(客户端发来数据)
ChannelOutBoundHandler 出栈(写)
Duplex 既是入栈处理器，又是出栈处理器