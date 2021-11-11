## Bean
1. Bean 名称生成器(BeanNameGenerator)
2. Spring 2.0.3引入实现，其有两种实现，
    - 默认通过 DefaultBeanNameGenerator
    - AnnotationBeanNameGenerator基于注解扫描的BeanNameGenerator实现
3. 通过Introspector.decapitalize(shortClassName)生成bean的名称
4. BeanDefinition注册三种方式
    1. XML配置原信息 <bean name="xx" class=""></bean>
    2. Java注解配置 @Bean @Component @Import
    3. Java API配置元信息
        - 命名方式: BeanDefinitionRegistry#registerBeanDefinition(String,BeanDefinition)
        - 非命名方式: BeanDefinitionReaderUtils#registerWithGeneratedName(AbstractBeanDefinition,BeanDefinition)
        - 配置类方式: AnnotatedBeanDefinitionReader#register(Class...)
        
5. 实例化Bean的几种方式
    - 常规方式
        1. 通过构造器(通过配置XML、Java注解，Java API)
        2. 通过静态工厂方法(配置元信息: XML和Java API)
        3. 通过Bean工厂方法(配置元信息: XML和Java API)
        4. 通过FactoryBean(配置元信息: XML、Java 注解和Java API)
    - 非常规方式
        1. 通过ServiceLoaderFactoryBean
        2. 通过AutoCapableBeanFactory#createBean(java.lang.Class,int,boolean)
        3. 通过BeanDefinitionRegistry#registerBeanDefinition(String,BeanDefinition)
        