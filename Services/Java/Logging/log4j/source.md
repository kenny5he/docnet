### Slf4j 
LoggerFactory.getLogger 方法会调用获取getILoggerFactory方法通过其初始化状态调用performInitialization执行初始化动作，通过bind方法，bind方法会通过ClassLoder加载指定类org.slf4j.impl.staticLoggerBinder，(slf4j-log4j12.jar) (logback-classic.jar) 均通过该类的getLoggerFacotory方法获取具体实现的日志工厂类。

#### Slf4j 实现适配
Slf4j的Logger在基于Log4j实现时实际上是Log4jLoggerAdpter的适配实现， 通过其org.apache.log4j.Logger进行具体功能的实现

##### Log4j篇：
当然我们在获取org.apache.log4j.Logger时会通过LogManager进行管理创建，在创建过程中通过LoggerContextFactory 创建日志上下文，在创建日志上下文时会有ContextSeletor看我们所使用的日志上下文是默认的ClassLoaderContextSelector还是通过实现OSGI自定义的BundleContextSelector 或者是创建异步日志上下文的AsyncLoggerContextSelector，在创建日志上下文的时候会调用locateContext(真正调用加载配置、创建日志上下文的地方)，ctx.setConfigLocation 会调用reconfigure，其通过ConfigurationFactory类的 getConfiguration方法加载log4j2等文件名的日志配置文件
