### Bean 模块
#### 注解
- @Value
    - 作用: 将常量、配置文件中的值、其他bean的属性值注入到变量中，作为变量的初始值
    - 案例
        - 常量:
            ```java
            @Value("normal")
            private String normal;
            ```
        - 表达式:
            ```java
            @Value("#{11*2}")
            private Integer age;
            ```
        - 常规方式:
            ```java
            @Value("${student.name}")
            private String name;                     
            ```
        - 默认值:
            ```java
            @Value("${student.name:张三}")
            private String name;                     
            ```
### Context 模块
#### 注解
- @Bean
    - 作用: 依赖注入
    - 同xml配置
        ```xml
        <bean id ="userService" class="com.xxx.it.demo.service.impl.UserService"></bean>
        ```
- @ComponentScan
    - 作用: 扫描自动装配包
    - 同xml配置:
    - 参考Blog: https://blog.csdn.net/luojinbai/article/details/85877956
    ```xml
    <context:component-scan base-package="com.xxx.it.*"/>
    ```
- @ComponentScans
    - 作用: 声明多个@ComponentScan
- @Configuration
    - 作用: 表明是一个配置类，可以启动主键扫描
    - 区别: 
        - @Configuration对@Component进行CGlib增强，使配置类中的@Bean方法互相调用时，保证其单例
- @DependsOn
    - 作用: 定义Bean初始化及销毁时的顺序
- @EnableAspectJAutoProxy
    - 作用: 开启AOP
- @Import
    - 作用: 引入配置
- @ImportResource
    - 作用: 引入资源文件
    - 同xml配置:
        ```xml
        <import resource="lookup.ehcache.xml"/>
        ```
- @Lazy
    - 作用: 懒加载
    - 同xml配置:
        ```xml
        <bean id ="userService" class="com.xxx.it.demo.service.impl.UserService" lazy-init="true"></bean>
        ```
- @Primary
    - 作用: 自动装配时当出现多个Bean候选者时，被注解为@Primary的Bean将作为首选者，否则将抛出异常
- @Profile
    - 作用: 根据spring.profiles.active限定范围生效(dev/sit/perf/production)
- @PropertySource
    - 作用: 引入属性配置文件，将属性配置文件中的值加载到对应属性中
    - 案例:
        ```java
        //@ConfigurationProperties(prefix="student")//spring boot
        @PropertySource(value = {"classpath:student.properties"})
        public class Student{
            @Value("${student.name}")
            private String name;
            @Value("${student.age}")
            private String age;
        }
        ```
        ```properties
          # student.properties
          student.name=张三
          student.age=18
        ```
- @Role
- @Validated
    - 作用: 对标记类/属性校验
    - 相同作用注解: javax.validation.Valid
- @Async
- @Schedules

### Web Servlet 模块
#### 注解
- @Mapping
- @CookieValue
- @ControllerAdvice
- @ResponseStatus
- @ResponseBody
- @RequestPart
- @RequestHeader
- @ExceptionHandler