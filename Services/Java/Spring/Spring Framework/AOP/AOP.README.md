### AOP(Aspect-Oriented programming 面向切面编程):
- 基本概念:
    - 通知(advice)
        - 作用: 通知定义了切面是什么以及何时使用。除了描述切面要完成的工作，通知还解决何时执行这个工作
        - Spring Aop可用通知类型:(前置、后置、异常、最终、环绕)
            - Before——在方法调用之前调用通知
            - After——在方法完成之后调用通知，无论方法执行成功与否
            - After-returning——在方法执行成功之后调用通知
            - After-throwing——在方法抛出异常后进行通知
            - Around——通知包裹了被通知的方法，在被通知的方法调用之前和调用之后执行自定义的行为

    - 连接点(join point)
        - 连接点是一个应用执行过程中能够插入一个切面的点
        - 连接点可以是调用方法时、抛出异常时、甚至修改字段时、切面代码可以利用这些点插入到应用的正规流程中
        - 程序执行过程中能够应用通知的所有点
    - 切面(Aspect)
        横切关注点被模块化为特殊的类，这些类称为切面
    - 横切(cross-cutting)

    - 关注点(concern)

    - 切点(point cut)
        指定一个通知将被引发的一系列连接点的集合
    - 引入（introduce)
        引入允许我们向现有的类中添加方法或属性
    - 织入(Weaving)
        组装切面来创建一个被通知对象
- execution表达式规则
    - *只能匹配一级路径 
    - ..可以匹配多级，可以是包路径，也可以匹配多个参数
    - +只能放在类后面，表明本类及所有子类

- XML使用配置解释

    |AOP配置元素	|               描述|
    |---|---|
    |aop:advisor|	            定义AOP通知器|
    |aop:before|	            定义 AOP 前置通知|
    |aop:after|	                定义AOP后置通知（不管被通知方法是否执行成功）|
    |aop:after-returing|	    定义AOPafter-returing 通知|
    |aop:after-throwing|	    定义AOPafter-throwing 通知|
    |aop:around|	            定义AOP环绕通知|
    |aop:aspect|	            定义切面|
    |aop:aspectj-autoproxy|	    启动 @AspectJ 注解驱动的切面|
    |aop:config|	            顶层的 AOP 配置元素，大多数 aop : * 元素必须包含在 元素内|
    |aop:declare-parents|	    为被通知的对象引入额外接口，并透明的实现|
    |aop:pointcut|	            定义切点|

- AspectJ

    |AspectJ指示器|	        描述|
    |---|---|
    |arg()	                |限制连接点的指定参数为指定类型的执行方法|
    |@args()	            |限制连接点匹配参数由指定注解标注的执行方法|
    |execution()	        |用于匹配连接点的执行方法|
    |this()                 |限制连接点匹配 AOP 代理的 Bean 引用为指定类型的类|
    |target()	            |限制连接点匹配特定的执行对象，这些对象对应的类要具备指定类型注解|
    |within()	            |限制连接点匹配指定类型|
    |@within()	            |限制连接点匹配指定注释所标注的类型（当使用 Spring AOP 时，方法定义在由指定的注解所标注的类里）v
    |@annotation	        |限制匹配带有指定注释的连接点|
    
    
### 问题
1. &lt;aop:aspect/&gt; 和&lt;aop:advisor/&gt;的区别？
    0. Adivisor是一种特殊的Aspect，Advisor代表spring中的Aspect
    1. 实现方式不同
        - &lt;aop:aspect&gt;定义切面时，只需要定义一般的bean就行，
        - &lt;aop:advisor&gt;中引用的通知时，通知必须实现MethodInterceptor接口
    2. advisor只持有一个Pointcut和一个advice，而aspect可以多个pointcut和多个advice
    3. aspect/advisor example
        ```
            <!-- blog: https://blog.csdn.net/weixin_41884446/article/details/102611813 -->
            <!--1、装配目标对象到ioc容器-->
            <bean id="customerService" class="com.microfoolish.dynamicProxy.jdk.CustomerServiceImpl"/>
            <!--2、装配通知（增强）对象-->
            <bean id="myAspectAdvice" class="com.smallkey.aopAdvice.MyAspectAdvice"/>
            
            <!--3、配置切点和切面，进行织入-->
            <aop:config>
                <!--配置切点-->
                <aop:pointcut id="myPointcut" expression="execution(* com.smallkey.dynamicProxy..*.*(..))"/>
                <!--配置切面-->
                <aop:aspect ref="myAspectAdvice">
                    <!--<aop:before method="before" pointcut-ref="myPointcut"/>-->
                    <!--<aop:after-returning method="afterReturning" returning="returnVal" pointcut-ref="myPointcut"/>-->
                    <!--<aop:around method="around" pointcut-ref="myPointcut"/>-->
                    <!--<aop:after-throwing method="afterThrowing" throwing="throwable" pointcut-ref="myPointcut"/>-->
                    <aop:after method="after" pointcut-ref="myPointcut"/>
                </aop:aspect>
            </aop:config>
        ```
    