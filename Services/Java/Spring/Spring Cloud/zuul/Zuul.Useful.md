### Zuul网关
### 概念/作用
- 网关是什么?
- Zuul的作用:
    1. 主要包含对请求的路由和过滤的功能
    2. 一般可以用作: 动态路由、安全认证、限流、静态响应处理
### 使用篇
##### Zuul路由配置使用
- 单实例配置
```yaml
zuul:
  routes:
      user-service:
        url: http://localhost:8585/
        path: /user/service/**
```
- 多实例配置
```yaml
zuul:
  routes:
      user-service:    
        path: /user/service/**
        serviceId: user-service
      role-service:
        path: /role/service/**
        serviceId: role-service
user-service:
  ribbon:
    listOfServers: http://localhost:8585/,http://localhost:8686
# 根据服务发现机制来获取配置服务名对应的实例清单
ribbon.eureka.enabled=false
```

#### Zuul Filter过滤功能的使用
- 简单实现Zuul过滤器
```java
public class AccessFilter extends ZuulFilter{
    /**
     * 过滤器的类型，决定过滤器在请求的哪个生命周期中执行
     * 类型选项: 
     *   pre: 代表会在被路由之前执行
     *   route: 代表会在路由请求时执行
     *   post: 代表会在路由请求后执行
     *   error: 代表路由失败执行
     *   static: 静态资源过滤，参阅: StaticResponseFilter
     */
    public String filterType(){
        return "pre";
    }
    /**
     * 过滤器执行顺序
     */
    public int filterOrder(){
        return 0;
    }
    
    /**
     * 判断过滤器是否需要被执行
     */
    public boolean shouldFilter(){
        return true;
    }

    /**
     * 判断过滤器运行时执行的逻辑
     */
    public Object run(){
        return null;
    }
}
```
- Zuul自带的过滤器
    - 位置: spring-cloud-neflix-core模块 org.springframework.cloud.netflix.zuul.filters包
    - pre 过滤器
        - ServletDetectionFilter:
    - route 过滤器
        - RibbonRoutingFilter
        - SimpleHostRoutingFilter
    - post 过滤器
        - SendErrorFilter
        - SendResponseFilter
    - error 过滤器
        - ThrowExceptionFilter
- 禁用过滤器:
  - 属性设置
  ```properties
    zuul.<SimpleClassName>.<fitlerType>.disable=true
    ```
  - 实现: 
    ```
        public String disablePropertyName() {
            return "zuul." + this.getClass().getSimpleName() + "." + filterType() + ".disable";
        }
    ```
#### Zuul过滤器核心处理器
1. FilterProcessor
    - 类: com.netflix.zuul.FilterProcessor
    - 作用: 过滤器核心处理器
    - 方法
        - getInstance(): 获取当前处理器的实例
        - setProcessor(FilterProcessor processor): 设置处理器实例，(自定义处理器)
        - processZuulFilter(ZuulFilter filter): 该方法定义了执行filter的具体逻辑，包括请求上下文的设置，判断是否应该执行，执行时异常的处理
        - runFilters(String sType): 根据出入的filterType来调用getFiltersByType获取排序后的过滤器列表，轮询过滤器，并调用processZuulFilter依次执行
        - preRoute(): 调用runFilters("pre")执行路由前执行逻辑
        - route(): 调用runFilters("route")
        - postRoute(): 调用runFilters("post")
        - error(): 调用runFilters("error")
2. FilterLoader  
    - 类: com.netflix.zuul.FilterLoader
    - 作用: 过滤器加载
    - 方法: 
        - getFiltersByType(String filterType): 根据传入的filterType获取网关对应类型的过滤器，并根据过滤器的filterOrder进行排序
#### 网关动态刷新、动态过滤器
- 动态加载过滤器
    - 配置
        - zuul.filter.root: 用来指定动态加载的过滤器存储路径
        - zuul.filter.interval: 用来配置动态加载的间隔时间
    - 实现
        ```
        public FilterLoader fitlerLoader(FilterConfiguration filterConfiguration){
            FilterLoader fitlerLoader = new FilterLoader();
            fitlerLoader.setCompiler(new GroovyCompiler());
            FilterFileManger.setFilenameFilter(new GroovyFileFitler());
            FilterFileManger.init(fitlerConfiguration.getInterval()),
            fitlerConfiguration.getRoot()+"/pre",
            fitlerConfiguration.getRoot()+"/post");
            return fitlerLoader;
          }
        ```
      