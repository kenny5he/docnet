同步: 正常调用
异步: 回调(无返回值)
阻塞: 正常调用(例: Scanner.in 控制台无输入情况则阻塞不往下执行)
非阻塞: 开线程执行

NIO(非阻塞性流)
    NIO三大概念:
    Buffer(Abstract): 存放传输数据
        Property: position、limit、capacity、mark
        Method: flip
        process:
            1. 初始化时 position 为下标为0的位置,capacity容量
            2. 当写入数据时，position移动到下个写入的位置
            3. 当读取数据时,limit移动到下一个写入的位置，position移动到0的位置，限定读取范围，读取完成后position恢复到下一个写入的位置
    Selector(Abstract):
        Selector是一个多路复用器，它负责管理被注册到其上的SelectableChannel
    Channel(Interface):
        Channel对应BIO中的Socket
        ServerSocketChannel(服务端)
        SocketChannel(客户端)




BIO(阻塞性流):


NIO与BIO的区别:
    1. 流的区别
      BIO 存在 InputStream、OutputStream
      NIO Buffer缓冲区多路复用(既可以写也可读)
    2.


JDK原生NIO selector.select()返回空问题解决？
增加timeout参数，计算执行时间，如果大于N次，则重新生成