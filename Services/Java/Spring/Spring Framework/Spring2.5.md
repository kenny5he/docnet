### Core 模块
#### 注解
- @Order
    - 作用: 控制配置类的加载顺序(值越大越先加载)
### Bean 模块
#### 注解
- @Autowired
   - 解析器(AutowiredAnnotationBeanPostProcessor)
   - 作用: 依赖注入
   - 相同作用注解: javax.inject.Inject
- @Qualifier
   - 解析器(CustomAutowireConfigurer)
   - 作用: 依赖注入，指定实现
   - 相同作用注解: javax.inject.Qualifier
- @Required
   - 解析器(RequiredAnnotationBeanPostProcessor)
   - 作用: 标记必须注入值
- @Configurable
   - 作用: 在非Spring管理的类中使用依赖注入
   - 案例:
        ```java
             
             public class Test{
                 /**
                  * 因Car为new出来的，并非 Spring容器托管的，故Car中的Engine未实例，导致报空指针异常
                  */
                 Car car = new Car();
                 car.startCar();
             }
             
             /**
              * 在调用Car的构造方法时，通过javaagent探针的方式为Car中的engine属性赋值
              * 依赖jar包: aspectj-x.x.x.jar, aspectjrt.jar, aspectjveawer-x.x.x.jar 
              * 部署启动应用时需配置  -javaagent:”PATH\spring-instrument-x.x.x.jar”
              */
             @Configurable(preConstruction = true)
             @Component
             public class Car {
                 @Autowired
                 private Engine engine;
              
                 public void startCar() {
                     engine.engineOn();
                     System.out.println("Car started");
                 }
             }
             @Component
             public class Engine {
                 public void engineOn(){
                     System.out.println("Engine On");
                 }       
             } 
        ```
### Context 模块
#### 注解
- @Scope
    - 作用: 创建单例Bean/原型bean/请求Bean(每次请求 新Bean)/Session Bean(Session期内)
    - 可选值: prototype/singleton/request/session 
    - 同xml配置
    ```xml
    <bean id ="userService" class="com.xxx.it.demo.service.impl.UserService" scope="singleton"></bean>
    ```
- @Component
    - 作用: 依赖注入，通用注解
    - 相同作用注解: javax.inject.Named
- @Repository
    - 作用: 依赖注入，作用于持久层
    - 对比: 
- @Service
    - 作用: 依赖注入，作用于服务层
- @Controller
    - 作用: 依赖注入，作用于服务层

### Aspect AOP模块
#### AspectJ 提供注解
- @AdviceName
- @After
- @AfterReturning
- @AfterThrowing
- @Around
- @Aspect
- @Before
- @DeclareAnnotation
- @DeclareError
- @DeclareMixin
- @DeclareParents
- @DeclarePrecedence
- @DeclareWarning
- @Pointcut
- @RequiredTypes
- @SuppressAjWarnings



### Web模块
#### 注解
- @EnableWebMvc
    - 作用: 开启Spring MVC
    - 同xml配置:
        ```xml
        <mvc:annotation-driven />
        ```
- @RequestParam
- @RequestMapping
- @SessionAttributes
- @ModelAttribute


### JSR330标准 javax.inject
- @Inject
    - 解析器(CommonAnnotationBeanPostProcessor)
- @Named
    - 作用: 同@Component
- @Provider
- @Qualifier
- @Scope
- @Singleton

### JSR250标准 javax.annotation
- @Generated
- @ManagedBean
- @PostConstruct
    - 作用: 用于指定初始化方法（用在方法上）
- @Priority
    - 作用: 指定优先级 
- @PreDestroy 
    - 作用: 用于指定销毁方法（用在方法上）
- @Resource
- @Resources
