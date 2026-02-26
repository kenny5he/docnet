## Feign
### Feign/OpenFeign Compare (Feign/OpenFeign 对比)
1. Feign是Spring Cloud组件中一个轻量级RESTful的HTTP服务客户端，Feign内置了Ribbon，用来做客户端负载均衡，去调用服务注册中心的服务。Feign的使用方式是：使用Feign的注解定义接口，调用接口，就可以调用服务注册中心的服务。
2. OpenFeign是Spring Cloud在Feign的基础上支持了SpringMVC的注解，如@RequestMapping等等。OpenFeign的@FeignClient可以解析SpringMVC的@RequestMapping注解下的接口，并通过动态代理的方式产生实现类，实现类中。
- 注意：openfeign 如果从框架结构上看就是2019年feign停更后出现版本，2018年以前的项目在使用feign

### OpenFeign


### Question
1. 如何为 Feign Https 请求设置 证书信息 ()
2. 如何 设置 Feign 重试策略? (FeignBlockingLoadBalancerClient)
3. Feign 负载均衡? (FeignLoadBalancerAutoConfiguration)

- CSDN 博客: https://blog.csdn.net/weixin_45433031/article/details/122994267
- CNBlog 博客: https://www.cnblogs.com/liconglong/p/15408858.html