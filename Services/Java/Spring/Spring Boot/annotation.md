### SpringBoot
#### Spring Boot 主模块
- @ConfigurationProperties
    - 作用: 加载属性配置文件
    - 参考: CxfProperties
- @ConfigurationPropertiesBinding
    - 作用: 指定自定义的转换器用于配置解析的时的类型转换
- @DeprecatedConfigurationProperty
    - 作用: 将配置属性标记为已弃用
- @EnableConfigurationProperties
    - 作用: 当某个属性配置类(@ConfigurationProperties)不适合全局扫描使用时，可使用@EnableConfigurationProperties带条件加载配置
    - 参考: CxfAutoConfiguration
- @NestedConfigurationProperty
    - 作用: 用于关联外部的类型作为嵌套配置类
- @SpringBootConfiguration
    - 作用: 
#### Spring Boot AutoConfiguration 自动配置模块
##### 自动配置注解
- @AutoConfigurationPackage
    - 作用: 自动配置加载包路径
- @AutoConfigureAfter
    - 作用: 设置自动配置类加载顺序，以及精确控制加载依赖关系,在加载自动配置类xx后加载当前类
- @AutoConfigureBefore
    - 作用: 设置自动配置类加载顺序，以及精确控制加载依赖关系,在加载自动配置类xx前加载当前类
- @AutoConfigureOrder
    - 作用: 设定自动配置顺序(值越小优先级越高)
- @EnableAutoConfiguration
    - 作用: 开启自动配置
- @ImportAutoConfiguration
    - 作用: 导入自动配置
- @SpringBootApplication
    - 作用: 标记为SpringBoot程序
##### Condition
- @ConditionalOnBean
    - 作用: 当容器中已经包含指定的Bean类型或名称时生效
- @ConditionalOnClass
    - 作用: 当classpath上存在指定类时条件匹配生效
- @ConditionalOnCloudPlatform
    - 作用: 当指定的云平台处于活动状态时条件匹配
- @ConditionalOnExpression
    - 作用: 作用于表达式为True时
    - 参考: CxfAutoConfiguration
- @ConditionalOnJava
    - 作用: 基于应用运行的JVM版本的条件匹配
- @ConditionalOnJndi
    - 作用: 基于JNDI可用和可以查找指定位置的条件匹配
- @ConditionalOnMissingBean
    - 作用: 当容器中不包含指定的Bean类型或名称时条件匹配
- @ConditionalOnMissingClass
    - 作用: 仅当classpath上不存在指定类时条件匹配
- @ConditionalOnProperty
    - 作用: 检查指定的属性是否具有指定的值
- @ConditionalOnResource
    - 作用: 当 classpath 上存在指定资源时条件匹配
- @ConditionalOnSingleCandidate
    - 作用: 当容器中包含指定的Bean类并且可以判断只有单个候选者时条件匹配
- @ConditionalOnWebApplication
    - 作用: 标记为Web程序起作用
- @ConditionalOnNotWebApplication
    - 作用: 标记为非Web程序起作用
