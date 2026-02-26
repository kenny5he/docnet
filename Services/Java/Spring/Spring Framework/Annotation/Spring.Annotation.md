## Spring Annotation 
1. Spring 注解编程模型
    1. 官方文档: https://github.com/spring-projects/spring-framework/wiki/Spring-Annotation-Programming-Model
    2. 元注解（Meta-Annotations）
        1. 释义: 标注在注解上的注解
        2. 例: 
    3. Spring 模式注解（Stereotype Annotations）
        1. 释义: 用于声明组件在应用程序中扮演的角色的注释
        2. 例:
            - @Repository 操作数据库
            - @Service    服务
            - @Controller MVC 与页面交互
    4. Spring 组合注解（Composed Annotations）
        1. 释义: 元注释关联的行为组合到单个自定义注释中
        2. 例: SpringBootApplication
            
    5. Spring 注解属性别名和覆盖（Attribute Aliases and Overrides）
        1. 释义:
        2. 例:
            - @AliasFor

### Spring 模式注解（Stereotype Annotations）
1. @Component “派⽣性”原理
    1. 核心组件 
        - org.springframework.context.annotation.ClassPathBeanDefinitionScanner
        - org.springframework.context.annotation.ClassPathScanningCandidateComponentProvider
    2. 资源处理 
        - org.springframework.core.io.support.ResourcePatternResolver
    3. 资源-类元信息
        - org.springframework.core.type.classreading.MetadataReaderFactory
    4. 类元信息 - org.springframework.core.type.ClassMetadata
        1. ASM 实现 - org.springframework.core.type.classreading.ClassMetadataReadingVisitor
        2. 反射实现 - org.springframework.core.type.StandardAnnotationMetadata
    5. 注解元信息 - org.springframework.core.type.AnnotationMetadata
        1. ASM 实现 - org.springframework.core.type.classreading.AnnotationMetadataReadingVisitor
        2. 反射实现 - org.springframework.core.type.StandardAnnotationMetadata

- 参考: https://www.freesion.com/article/5393222818/

### Spring Attributes 属性注解
1. @AliasFor ""原理
    1. 核心组件
    2. AnnotationAttributes 相当于一个Map
    3. 属性传递:
        1. 显示传递: 参考: ComponentScan 的 value 与 basePackageClasses
        2. 隐式传递: 
            ```
              
              @AliasFor(annotation = Xxxx.class, attribute = "no")
              String number() default ""; 
           ```
    4. 属性覆盖: 
        1. 注解B继承注解A，且注解A存在与注解B的同名属性 
        2. 隐式覆盖: 参考: TransactionalEventListener 的 classes 与 EventListener的 classes 

### Spring Enable 注解
1. Enable 注解实现
   - 基于 Configuration Class
   - 基于 ImportSelector 接口实现
   - 基于 ImportBeanDefinitionRegistrar 接口实现

### Spring 条件注解
1. @Conditional 实现原理
    1. 上下文对象 
        - org.springframework.context.annotation.ConditionContext
    2. 条件判断 
        - org.springframework.context.annotation.ConditionEvaluator
    3. 配置阶段
        - org.springframework.context.annotation.ConfigurationCondition.ConfigurationPhase
    4. 判断入口 
        - org.springframework.context.annotation.ConfigurationClassPostProcessor
        - org.springframework.context.annotation.ConfigurationClassParser
2. @Profile
   - 通过 spring active profile 方式加载 @Profile 对应的信息

### Spring Listener
1. @EventListener 的工作原理
    1. org.springframework.context.event.EventListenerMethodProcessor
2. @TransactionalEventListener 的工作原理
    
3. 扩展 @TenantEventListener
    1. 创建 TenantEventListenerFactory 实现 EventListenerFactory, Ordered 接口
    2. 创建 TenantApplicationListenerMethodAdapter 继承 ApplicationListenerMethodAdapter
    3. 为支持 @Async 异步 EventListener 

### Spring Async 


