## Tomcat基础使用配置篇
- catalina.home表示安装目录
- catalina.base表示工作目录

## Context/Host/Engine/Wrapper之间的关系
- Engine 
    List<Host> hosts;
    Pipeline pipeline; 
- Host 
    List<Context> contexts;
    Pipeline pipeline; 
- Context
    List<Wrapper> servlets;
    Pipeline pipeline; 
- Wrapper 对应某一个Servlet实例
    List<Servlet> servlets;
    Pipeline pipeline; 
- Servlet
    Servlet 可实现接口 SingleThreadModel(已弃用)接口，实现Servlet独享，未实现SingleThread接口则请求共用一个实例
- Pipeline(管道)
    List<Value> 阀门
- Tomcat处理请求过程
请求   --经过Tomcat封装-->    Request对象   -- 经过Engine阀门 -->   Engine    -- 经过Host阀门 -->     Host    -- 经过Context阀门 -->   Context

- Container

- EndPoint:通过不同的IO模型取数据
    1. JIOEndPoint == BIO 
       阻塞: serverSocketFactory.acceptSocket(serverSocket)
       处理: processSocket方法 调用SocketProcessor中实现线程的run方法处理请求
       Tomcat线程池: 父类AbstractEndPoint方法createExecutor,一个请求一个线程
        默认线程数量 100% ,如果活跃的线程数占线程池最大线程数的比例大于75%，则关闭KeepAlive,
    2. 
- Lifecycle
    1. init()，组件进行初始化
    2. start()，启动组件
    3. stop()，停止组件
    4. destroy()，销毁组件
    5. getState()，获取组件当前状态

### 自定义实现一个阀门
1. 实现接口 RequestFilterValue
    
### Request 在Tomcat中存在两个，有啥么不同
1. org.apache.catalina.connector.Request
    
2. org.apache.coyote.Request