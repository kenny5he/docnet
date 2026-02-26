## AOT 

### Jackson 使用 @Mixin 注解对目标类 字段名 调整 
0. 使用方式见: https://zhuanlan.zhihu.com/p/574264977
1. JacksonAutoConfiguration (Jackson 自动配置类)
2. JsonMixinModuleEntriesBeanRegistrationAotProcessor (实现 BeanRegistrationAotProcessor 接口，实现 processAheadOfTime 方法(类加载前处理、改造类的调用方法))
3. AotContribution (实现BeanRegistrationCodeFragmentsDecorator 类，对类 字节码片段修饰)
4. META-INF/spring/aot.factories 中声明实现类
```
org.springframework.beans.factory.aot.BeanRegistrationAotProcessor=\
org.springframework.boot.jackson.JsonMixinModuleEntriesBeanRegistrationAotProcessor
```
### HttpExchange 类型
1. 


- 参考博客: https://blog.csdn.net/qq_38526573/article/details/130756021
