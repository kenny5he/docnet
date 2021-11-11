### Core 模块
#### 注解
- @AliasFor
    - 作用: 别名
    - 案例: @Bean
### Bean 模块
#### 注解
- @Lookup
    - 作用: 实现方法注入
    - 案例: 
        ```java
        
        ```
    - 同xml配置: 
        ```xml
        <bean id="commandManager" class="fiona.apple.CommandManager">
            <lookup-method name="createCommand" bean="myCommand"/>
        </bean>
        ```
### Context 模块
#### 注解
- @Conditional
    - 作用: 带条件加载配置
    - 参考: OnWebApplicationCondition类与注解ConditionalOnWebApplication
    - 自定义:
        1. 实现Condition接口中的match方法
        2. 自定义注解并加上@Conditional注解指定match实现类
- @Description
    - 作用: 描述注解
    - 参考: https://www.jianshu.com/p/d74ed7374841
- @PropertySources
    - 作用: 引入多个@PropertySource
### Web Servlet模块
#### 注解
- @RestController
    - 作用: 支持Restful服务
- @RestControllerAdvice
- @SessionAttribute
- @CrossOrigin
- @GetMapping
- @PutMapping
- @PostMapping
- @PatchMapping
- @DeleteMapping