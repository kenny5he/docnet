## IOC 问题解答
1. BeanFactory 与FactoryBean的区别？
    1. BeanFactory是个Factory，也就是IOC容器或对象工厂，FactoryBean是个Bean.
    2. BeanFactory
       - ApplicationContext接口由BeanFactory接口派生而来，一般建议优先使用ApplicationContext
       - BeanFactory拥有唯一一个默认实现 DefaultListableBeanFactory
    3. FactoryBean
        - 一般用户可通过 FactoryBean 定制实例化 Bean的逻辑，对对象进行生产、修饰。
2. ApplicationContext 与 BeanFactory的区别？优先建议使用哪个？
    1. ApplicationContext
    2. BeanFactory

3. BeanFactory 与 ObjectFactory的区别？