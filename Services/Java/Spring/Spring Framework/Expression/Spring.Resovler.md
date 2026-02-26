## Spring ${} Resolver 原理
1. 程序入口
   1. AbstractApplicationContext#refresh
   2. ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory()
   3. NamespaceHandler 解析 xml 配置文件中的自定义命名空间；
   4. ContextNamespaceHandler 上下文相关的解析器，这边定义了具体如何解析 property-placeholder 的解析器；
   5. BeanDefinitionParser 解析 BeanDefinition 的接口，这里的 BeanDefinitionParser 为PropertyPlaceholderBeanDefinitionParser；
   6. BeanFactoryPostProcessor 加载好 BeanDefinition 后可以对其进行修改；
   7. PropertySourcesPlaceholderConfigurer 处理 BeanDefinition 中的占位符。
2. 解析标签
    1. ContextNamespaceHandler 加载 property-placeholder标签 解析类 PropertyPlaceholderBeanDefinitionParser
3. 解析符号
    2. PropertySourcesPlaceholderConfigurer#postProcessBeanFactory
    3. PropertySourcesPlaceholderConfigurer#processProperties 占用符解析
    4. PlaceholderResolvingStringValueResolver#replacePlaceholders
    5. PropertyPlaceholderHelper#parseStringValue

- 参考: https://blog.csdn.net/weixin_43477531/article/details/121281710