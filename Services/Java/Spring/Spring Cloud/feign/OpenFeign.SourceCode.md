# OpenFeign 源码解读

## OpenFeign 初始化过程
1. EnableFeignClients 注解
    1. 通过 注解 @Import 引入 FeignClientsRegistrar 类
    2. FeignClientsRegistrar 类实现 ResourceLoaderAware 资源加载类，获取 ResourceLoader
    3. FeignClientsRegistrar 类实现 ImportBeanDefinitionRegistrar (注册Bean)
        1. 获取 EnableFeignClients 的配置值，(扫描包、类、Clients)
        2. 扫描 FeignClient 类，(如果 EnableFeignClients 没有配置 clients 则会到 FeignClient 获取 basePackages 信息)
        3. 根据 Class、URL、Path等信息 实例化 FeignClientFactoryBean，并注册 Bean
    4. 因FeignClientFactoryBean为 FactoryBean的实现类，通过 getTarget 获取其代理对象
       1. 注册 Bean 时，会调用 初始化 目标对象，通过 FeignClientFactoryBean#feign
          1. Feign客户端进行配置 FeignClientFactoryBean#configureFeign
              1. configureUsingConfiguration 解析 
                  1. 获取 FeignClientProperties 属性配置信息(RequestInterceptor、ResponseInterceptor、QueryMapEncoder)
                  2. 获取 FeignClientConfigurer
              2. configureUsingProperties 解析连接时间、超时时间等信息
                  - 例：default配置
                  ```yaml
                  feign:
                    client:
                      config:
                        default: 
                          connectTimeOut: 5000
                          readTimeOut: 10000
                          loggerLevel: full
                  ```
          2. 获取 Targeter 并调用 target 方法
              1. 通过 Feign.Builder 构建的 Feign 对象，调用 target 方法
              2. Fegin 构建 并 新建实例 ReflectiveFeign
              3. ReflectiveFeign 反射、代理方法具体执行
    5. LoadBalance 负载均衡处理
        1. FeignClientsConfiguration 配置
        2. FeignClientFactory 
        3. FeignBlockingLoadBalancerClient (负载均衡)
        4. FeignCircuitBreakerTargeter (熔断限流)
    6. 重试机制:
        1. FeignClientsConfiguration#feignRetryer
        2. 默认不重试
2. 自动配置
    1. FeignClientsConfiguration
        1. 通过 feignBuilder 方法，构造器 Feign.Builder
    2. FeignAutoConfiguration
        - 初始化: FeignClientFactory
        - 默认 Targeter: defaultFeignTargeter
3. Spring MVC 注解支持
    1. SpringMvcContract
    2. 参数化处理 (默认初始化方法: getDefaultAnnotatedArgumentsProcessors)
        - MatrixVariableParameterProcessor
        - PathVariableParameterProcessor
        - RequestParamParameterProcessor
        - RequestHeaderParameterProcessor
        - QueryMapParameterProcessor
        - RequestPartParameterProcessor
        - CookieValueParameterProcessor

## OpenFeign JAX-RS 支持
### Jakarta
1. 添加依赖
```
<dependency>
    <groupId>io.github.openfeign</groupId>
    <artifactId>feign-jakarta</artifactId>
    <version>12.5</version>
</dependency>
```
2. 配置 Contract
```

```
### OpenFeign Soap 支持

### OpenFeign 扩展
1. 构建阶段 客制化 扩展
    1. 扩展接口类:  FeignBuilderCustomizer