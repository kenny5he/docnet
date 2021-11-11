

1.在哪里创建的服务端socket
2.在哪里accept连接？

反射创建服务端channel    (NioServerSocketChannel)
  newSocket()  【通过jdk来创建底层jdk  channel】
  NioServerSocketChannelConfig() 【tcp参数配置】
  AbstractNioChannel()
	ch.configureBlocking(false);  【设置非阻塞模式】
	AbstractChannel()   【创建id，unsafe,pipeline】
	
init()   【初始化入口】
	setChannelOptions()  attr();
	setChildOptions  childAttrs();
	config handler  【配置服务端pipeline】
	add ServerBootStrapAcceptor    【添加连接器】
	
	
register【注册selector入口】
	AbstractChannel.register(channel)   【入口】
	AbstractChannel.this.eventLoop = eventLoop;  【绑定线程】
	register0()    【实际注册】
		doRegister()  【调用jdk底层注册】
		invokeHandlerAddedIfNeeded()
		fireChannelRegistered    【传播事件】
	
	
		
初始化服务端Channel
  bind()   【用户代码入口】
  initAndRegister()  【初始化并注册】
		newChannel() 【创建服务器channel】
		init()       【初始化服务器channel】
		register()   【注册selector】
		
端口绑定
AbstractUnsafe.bind()   【入口】
	doBind()
		NioServerSocketChannel.javaChannel().bind()   【jdk底层绑定】
	pipeline.fireChannelActive();	  【传播事件】
		readIfIsAutoRead() 



1.默认情况下，netty服务端起多少线程，何时启动？
2.netty是如何解决jdk空轮询bug的？

NioEventLoopGroup创建流程
	new NioEventLoopGroup();   【nThreads=默认CPU核数的两陪】
	new ThreadPerTaskExecutor(newDefaultThreadFactory())   【线程创建器】
		每次执行任务的时候都会创建一个线程实体
		NioEventLoop线程命名规则nioEventLoop-1-xx
	for( nThreads次  ){ newChild() }   【创建NioEventLoop】
		newChild()-->
					保存线程执行器ThreadPerTaskExecutor
					PlatformDependent.<Runnable>newMpscQueue()
					创建一个selector
	chooserFactory.newChooser(children);  【线程选择器】
		
		
	
serverSocketChannel.socket()




Java通过Executors提供四种线程池，分别为：
newCachedThreadPool创建一个可缓存线程池，如果线程池长度超过处理需要，可灵活回收空闲线程，若无可回收，则新建线程。
newFixedThreadPool 创建一个定长线程池，可控制线程最大并发数，超出的线程会在队列中等待。
newScheduledThreadPool 创建一个定长线程池，支持定时及周期性任务执行。
newSingleThreadExecutor 创建一个单线程化的线程池，它只会用唯一的工作线程来执行任务，保证所有任务按照指定顺序(FIFO, LIFO, 优先级)执行。





Netty基础相关问题



讲讲Netty的特点？
 高并发
Netty是一款基于NIO（Nonblocking I/O，非阻塞IO）开发的网络通信框架，对比于BIO（Blocking I/O，阻塞IO），他的并发性能得到了很大提高 。
 传输快
Netty的传输快其实也是依赖了NIO的一个特性——零拷贝。
 封装好
Netty封装了NIO操作的很多细节，提供易于使用的API。


BIO、NIO和AIO的区别？
https://blog.csdn.net/skiof007/article/details/52873421



NIO的组成是什么？
selector，channel，buffer

Selector:  Selector是一个多路复用器，它负责管理被注册到其上的SelectableChannel
  多路复用的实现方式(根据操作系统不同): select、poll、epoll、kqueue


如何使用 Java NIO 搭建简单的客户端与服务端实现网络通讯？
如何使用 Netty 搭建简单的客户端与服务端实现网络通讯？

讲讲Netty 底层操作与 Java NIO 操作对应关系？
netty主要对java NIO进行了封装，方便了我们使用

Channel 与 Socket是什么关系？
Socket：网络上的两个程序通过一个双向的通信连接实现数据的交换，这个连接的一端称为一个socket，
Channel：是一个链接，它提供了如下的功能。
1：获取当前链接的状态
2：配置当前链接参数
3：进行read,write,connect,bind等通道支持的操作。
4：该Channel关联的ChannelPipeLine处理所有的IO事件和绑定在这个channel的请求

Channel 与 EventLoop是什么关系？
一个Channel在它的生命周期内只注册于一个EventLoop；
一个EventLoop可能会被分配给一个或多个Channel

Channel 与 ChannelPipeline是什么关系？
一个Channel包含了一个ChannelPipeline,而ChannelPipeline中又维护了一个由ChannelHandlerCOntext组成的双向链表，
这个链表的头是HeadContext,链表的尾是TailContext,并且么个ChannelHandlerContext中又关联着一个ChannelHandler;


EventLoop与EventLoopGroup 是什么关系？
NioEventLoopGroup是NioEventLoop的组合，用于管理NioEventLoop
EventLoop接口用于处理连接的生命周期中所发生的事件。一个EventLoop在它的生命周期内只和一个Thread绑定。所有由EventLoop处理的I/O事件都将在它专有的Thread上被处理


Netty 的线程模型是什么？
这个要看我们如何编码；NioEventLoopGroup默认线程数为cpu核心数的两倍
如果用了两个NioEventLoopGroup，且指定工作线程数不为一，则是主从多线程模型；
如果用了两个NioEventLoopGroup，且指定工作线程数为一，则是主从单线程模型
如果用了一个NioEventLoopGroup，且指定线程数不为一，则是多线程模型
如果用了一个NioEventLoopGroup，且指定线程数为一，则是单线程模型

netty  bossGroup默认为CPU核数的两倍的作用？
https://stackoverflow.com/questions/34275138/why-do-we-really-need-multiple-netty-boss-threads



粘包与半包和分隔符相关问题

什么是粘包与半包问题?

粘包与半包为何会出现?
如何避免粘包与半包问题？
如何使用包定长 FixedLengthFrameDecoder 解决粘包与半包问题？原理是什么？
如何使用包分隔符 DelimiterBasedFrameDecoder 解决粘包与半包问题？原理是什么？
Dubbo 在使用 Netty 作为网络通讯时候是如何避免粘包与半包问题？
Netty框架本身存在粘包半包问题？
什么时候需要考虑粘包与半包问题？

WebSocket 协议开发相关问题
讲讲如何实现 WebSocket 长连接？
讲讲WebSocket 帧结构的理解？浏览器、服务器对 WebSocket 的支持情况如何使用 WebSocket 接收和发送广本信息？
如何使用 WebSocket 接收和发送二进制信息？

Netty源码分析相关问题

服务端如何进行初始化？

何时接受客户端请求？
服务端（reactor线程）启动后就可以接收

何时注册接受 Socket 并注册到对应的 EventLoop 管理的 Selector ？
在channel通道创建和初始化完毕后，会通过group.register()方法将channel通道注册到EventLoop线程池中；
从线程池中轮询获取一个线程EventLoop并与之绑定；而EventLoop线程池会绑定一个selector选择器

客户端如何进行初始化？

何时创建的 DefaultChannelPipeline ？
服务端channel被反射创建时被创建



ByteBuf的分类：
Pooled和Unpooled--》Pooled从已经分配好的内存取内存   Unpooled新创建一块内存
Unsafe和非Unsafe--》Unsafe依赖于jdk底层Unsafe对象    非Unsafe不依赖于jdk底层Unsafe对象
Heap和Direct    --》Heap底层就是byte数组             Direct依赖于Nio的ByteBuffer创建出DirectByteBuffer，堆外内存




netty当中的解码器
1.FixedLengthFrameDecoder  基于固定长度的解码器
2.LineBasedFrameDecoder    基于行（\n,\r）的解码器
3.DelimiterBasedFrameDecoder 基于分隔符的解码器
4.LengthFieldBasedFrameDecoder  基于长度的解码器





反射创建NioServersocketchannel（包装了Serversocketchannel）并设置非阻塞，保存了感兴趣的事件
将ChannelInitializer加入pipeline中，此时pipeline中就是head-->ChannelInitializer-->tail
将NioServersocketchannel注册到selector上，设置附加属性为AbstractNioChannel，感兴趣的事件为0
pipeline中的结构为head-->ChannelInitializer-->NettyTestHendler-->tail       （在注册完时会执行handlerAdded方法，而ChannelInitializer的handlerAdded，就是调用initChannel方法）
pipeline中的结构变为head-->NettyTestHendler-->tail

pipeline中的结构变为head-->NettyTestHendler-->ServerBootstrapAcceptor-->tail


客户端pipeline
新接连接入的时候pipeline中就是head-->ChannelInitializer（启动类我们自己编写的）-->tail
pipeline中的结构变为head-->用户自定义的ChannelHandler-->tail




















		
 		