# Spring Boot 扩展点
### ApplicationContextInitializer
1. 加载时机：
    - Spring 容器刷新之前初始化 ConfigurableApplicationContext 的回调接口
    - 刷新容器前，会调用该接口的 initialize 方法
2. 使用场景：
    - 激活配置
    - 利用类加载器加载类之前的时机执行 动态字节码 注入等操作
3. 扩展加载
    1. 在启动类中添加
    ```
    application.addInitializers(new CustomApplicationContextInitializer())
    ```
    2. 在配置文件中配置
    ```
    context.initializer.classes=com.microfoolish.it.framework.jalova.context.CustomApplicationContextInitializer
    ```
    3. 使用 Spring SPI扩展
        - 文件：spring.factories
        ```
        org.springframework.context.ApplicationContextInitializer=com.microfoolish.it.framework.jalova.context.CustomApplicationContextInitializer
        ```
### BeanDefinitionRegistryPostProcessor
1. 加载时机:
    - 读取项目中的 BeanDefinition 后执行
2. 使用场景:
    - 注册自定义的 BeanDefinition，并加载类路径之外的 Bean

### BeanFactoryPostProcessor
1. 该接口是对 BeanFactory 的扩展
2. 加载时机:
    - Spring读完 BeanDefinition信息之后，Bean实例化之前
3. 使用场景:
    - 修改已注册的 BeanDefinition 元数据

### InstantiationAwareBeanPostProcessor
1. 该接口继承 BeanPostProcessor 接口
   - 区别： 
       - BeanPostProcessor 接口只在 Bean的初始化阶段（注入Spring上下文之前和之后）扩展
       - InstantiationAwareBeanPostProcessor 接口增加了三个方法 扩展了bean的实例化和属性注入阶段的作用范围
2. 类方法
    - postProcessBeforeInstantiation: 实例化 Bean 之前，创建 Bean 之前
    - postProcessAfterInstantiation: 实例化 Bean 之后，创建 Bean 之后
    - postProcessPropertyValues: Bean 实例化之后，在属性注入阶段触发，@Autowired、@Resource
    - postProcessBeforeInitialization: Bean 注入 Spring 上下文之前
    - postProcessAfterInitialization: Bean 注入Spring 上下文之后
3. 使用场景:
    - 中间件开发
    - 在Bean生命周期的不同阶段收集实现接口的Bean，为某类型的Bean统一设置属性 

### SmartInstantiationAwareBeanPostProcessor
1. 类方法