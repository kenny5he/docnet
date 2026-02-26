## Spring Event
### Spring 应用事件 ApplicationEvent

#### 应用上下文事件 - ApplicationContextEvent
|执行顺序 |Spring Boot事件| 事件类 | 事件触发时机 | 事件监听器 |
| --- | --- | --- | --- |--- |
|1|上下文就绪事|ContextRefreshedEvent|context.refresh()||
|2|上下文启动事件|ContextStartedEvent|context.start()||
|3|上下停止事件|ContextStoppedEvent|context.stop()||
|4|上下文关闭事件|ContextClosedEvent|context.close()||

#### Spring 事件 - SpringApplicationEvent  (SpringBoot)
|执行顺序 |Spring Boot事件| 事件类 | 事件触发时机 | 事件监听器 |
| --- | --- | --- | --- |--- |
| | 应用启动事件 |ApplicationStartingEvent| | |
| | 应用启动完成事件 |ApplicationStartedEvent| | |
| | 应用咦准备事件 |ApplicationPreparedEvent| | |
| | 应用完成事件 |ApplicationReadyEvent| | |
| | 应用失败事件 |ApplicationFailedEvent| | |
| | Environment 已准备事件|ApplicationEnvironmentPreparedEvent| | |


#### SpringCloud 事件
|执行顺序 |Spring Boot事件| 事件类 | 事件触发时机 | 事件监听器 |
| --- | --- | --- | --- |--- |
| | Environment 配置属性发生变化事件 |EnvironmentChangeEvent| | |
| | DiscoveryClient 客户端发送心跳时 |HeartbeatEvent| | |
| | 服务实例注册前 |InstancePreRegisteredEvent| | |
| | 服务实例注册后 |InstanceRegisteredEvent| | |
| | RefreshEndpoint 被调用事件 |RefreshEvent| | |
| | Refresh Scope Bean 刷新后事件 |RefreshScopeRefreshedEvent| | |


#### WebSocket事件 
WebSocket 事件由 StompSubProtocolHandler 分类统一进行触发。

|执行顺序 |Spring Boot事件| 事件类 | 事件触发时机 | 事件监听器 |
| --- | --- | --- | --- |--- |
||Session 连接事件 |SessionConnectEvent|||
||Session 连接完成事件 |SessionConnectedEvent|||
||发布消息|SessionSubscribeEvent|||
||离开聊天|SessionUnsubscribeEvent|||
||Session 断连事件 |SessionDisconnectEvent|||

### Spring 事件监听 ApplicationListener

| 特性 | 说明 |
| --- | --- |
|设计特点| 支持多 ApplicationEvent 类型，无需接口约束 |
|注解目标| 方法 |
|是否支持异步执行| 支持 |
|是否支持泛型类型事件|支持|
|是指支持顺序控制|支持，配合 @Order 注解控制|

1. 设计特点: 单一类型事件处理
2. 处理方法：onApplicationEvent(ApplicationEvent)
3. Spring 事件监听注解
    - @org.springframework.context.event.EventListener
4. 如何注册 Spring 的 ApplicationListener？
    1. ApplicationListener 作为 Spring Bean 注册
    2. 通过 ConfigurableApplicationContext API 注册

###  Spring 事件发布器
1. 事件发布方式
    1. 通过 ApplicationEventPublisher 发布 Spring 事件 (依赖注入)
        1. 通过实现 ApplicationEventPublisherAware 类获取 ApplicationEventPublisher
        2. 通过@Autowired ApplicationEventPublisher
    2. 通过 ApplicationEventMulticaster 发布 Spring 广播事件 (依赖注入、依赖查找)
        1. Bean 名称："applicationEventMulticaster"
        2. Bean 类型：org.springframework.context.event.ApplicationEventMulticaster
2. ApplicationEventMulticaster 广播的底层实现
    1. 抽象类: AbstractApplicationEventMulticaster
    2. 实现类: SimpleApplicationEventMulticaster
        1. 设计模式: 观察者模式
            1. 被观察者: org.springframework.context.ApplicationListener
                - 依赖查找
                - API 添加
            2. 通知对象: org.spring.framework.context.ApplicationEvent 
        2. 执行模式: 同步/异步
        3. 异常处理: org.springframework.util.EventHandler
        4. 泛型处理: org.springframework.core.ResolvableType
3. Publisher 和 Multicaster的区别
    1. ApplicationEventPublisher：是一个封装事件发布接口，作为ApplicationContext父类接口。
    2. ApplicationEventMulticaster：管理ApplicationListener对象，并且发布。
4. 同步与异步事件
    1. 基于实现类: SimpleApplicationEventMulticaster
    2. 默认为同步 
    3. 模式切换:  
        1. setTaskExecutor
        2. @Async 注解方式