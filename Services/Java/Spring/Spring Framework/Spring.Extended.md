# Spring Framework 扩展
1. XML 配置标签扩展
    1. 继承抽象类 NamespaceHandlerSupport
    2. 实现init方法
        ```java
        @Override
        public void init() {
            registerBeanDefinitionParser("annotation-driven", new AnnotationDrivenCacheBeanDefinitionParser());
            registerBeanDefinitionParser("advice", new CacheAdviceParser());
        }
        ```
    3. 解析类继承实现抽象类 AbstractSingleBeanDefinitionParser
    4. 参考实现: org.springframework.cache.config.CacheNamespaceHandler

2. 配置中心读取配置增强
    1. PlaceholderConfigurerSupport
   
3. 缓存增强
    1. 继承 AbstractCacheManager 类
    2. 实现方法 loadCaches,加载读取缓存配置
   
4. 解析读取xml文件配置,通过 BeanDefinitionRegistryPostProcessor注册bean

5. MessageSource 数据库读取增强

