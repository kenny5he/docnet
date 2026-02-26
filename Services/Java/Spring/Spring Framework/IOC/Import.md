## Import 注解
1. ImportBeanDefinitionRegistrar 动态注册Bean的能力
2. 子类接口: 
    1. MapperScannerRegistrar: Mybatis @MapperScan 注解扫描注册
    2. LoadBalancerClientConfigurationRegistrar: 服务端负载均衡
    

## ImportSelector注解
1. ImportSelector接口是至spring中导入外部配置的核心接口,作用是收集需要导入的配置类
2. 子类接口
    - DeferredImportSelector: 在所有的@Configuration处理完,导入配置
    - AdviceModeImportSelector: 限定选择条件只能是AdviceMode枚举类，也就是说你自定义的注解必须包含AdviceMode属性
3. 参考实现: TransactionManagementConfigurationSelector
4. Enabled 的实现方式: 
    1. EnableCircuitBreakerImportSelector: 断路器 @EnableCircuitBreaker 的实现
    2. EnableDiscoveryClientImportSelector: 服务注册 @EnableDiscoveryClient 的实现

