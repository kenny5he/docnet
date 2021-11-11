IOC/DI(依赖注入)
    1)核心类(XmlBeanFactory 继承 DefaultListableBeanFactory，并调用 XmlBeanDefinitionReader)   
      (1)XML 资源加载核心类：XmlBeanDefinitionReader(path --> Resource --> Document --> Element)
        ①基础接口定义
          InputSteam 定义获取流
          Resource 定义文件是否存在/是否可读/是否打开
          ConextResource 定义获取jar包中的文件路径(getPathWithinContext)
        ②Spring 获取资源
          URL资源：URLResource
          ClassPath：ClasspathResource/ClassRelativeContextResource
          文件系统：FileSystemResource
          ByteArrayResource
          DescriptionResource
        ③XML配置文件读取
          基础接口定义：
            资源定位
                InputStreamSource(Interface) (唯一存在的方法 getInputStream)
                Resource(Interface) 获取基本的资源信息(方法:exists isReadable isOpen isFile getURL getURI getFile getFilename...)
                AbstractResource(Abstract) Resource接口公共实现
                ResourceLoader(Interface) 资源加载器
                ResourcePatternResolver(Interface) 资源路径匹配,ResourceLoader的扩展，支持getResources()新增协议前缀 "classpath*:"
                PathMatchingResourcePatternResolver(Class)(实现ResourcePatternResolver) 路径资源匹配溶解器,支持ant风格匹配模式(**/)
            装载(根据资源定位返回的Resource信息)(XML Resource => XML Document => Bean Definition)
                BeanDefinition(Interface) (描述了一个 Bean 实例的定义，包括属性值、构造方法值和继承自它的类的更多信息)
                    BeanDefinitionReader(Interface)
                    XmlBeanDefinitionReader(Class)(核心类) XML 验证模式探测器，XML(?DTD/XSD?)
                    XmlValidationModeDetector(Class) 逐行读取xml返回模式 (是否包含注释)
                    BeansDtdResolver dtd验证
                    PluggableSchemaResolver xsd验证
                Document
                    DocumentLoader(Interface)
                    DefaultDocumentLoader
            注册
                BeanDefinitionRegistry
                DefaultBeanDefinitionDocumentReader 解析xml 解析标签
                BeanDefinitionParserDelegate 解析bean

                EnvironmentCapable 获取Evironment方法
                DocumentLoadler 从资源文件加载转换为Document功能

      (2)Bean 容器核心工具类：DefaultListableBeanFactory(注册/加载bean核心实现)(XmlBeanFactory 继承--> DefaultListableBeanFactory)
              ①基础接口定义
                BeanFactory 定义获取各个Bean属性
                SingletonBeanFactory 定义单例注册获取
                BeanDefinitionRegistry 定义对BeanDefinition的增删改操作
                AliasRegistry 定义alias 增删改
                ConfigurableBeanFactory 提供配置Factory的各种方法
                ListableBeanFactory 获取Bean的配置清单
                AutowireCapableBeanFactory 定义创建Bean 自动注入 初始化以及应用Bean后的处理器
      (3)xml验证
         ①DTD(Document Type Definition)是一种xml约束模式语言
           作用：查看文档是否符合规范，元素标签是否正确
           内容：元素定义规则/元素间关系的定义规则/元素的可用性/可使用实体或符号规则
           缺点:
                1. 它没有使用 XML 格式，而是自己定义了一套格式，相对解析器的重用性较差；而且 DTD 的构建和访问没有标准的编程接口，因而解析器很难简单的解析 DTD 文档。
                2. DTD 对元素的类型限制较少；同时其他的约束力也叫弱。
                3. DTD 扩展能力较差。
                4. 基于正则表达式的 DTD 文档的描述能力有限。
         ②XSD(XML Schemas Definition)(W3C 在 2001 年针对DTD的缺陷设计推出XSD)
           作用：描述文档结构
           优点:
                1. XML Schema 基于 XML ，没有专门的语法。
                2. XML Schema 可以象其他 XML 文件一样解析和处理。
                3. XML Schema 比 DTD 提供了更丰富的数据类型。
                4. XML Schema 提供可扩充的数据模型。
                5. XML Schema 支持综合命名空间。
                6. XML Schema 支持属性组。
         ③核心验证处理(xmlValidationModeDetector)(判断是否包含DOCTYPE have?DTD:XSD)
         ④EntityResolver
           作用：项目本身寻找DTD声明的方法(将DTD文件放置在项目内)
           (自定义解析blog: http://svip.iocoder.cn/Spring/IoC-parse-BeanDefinitions-in-parseCustomElement/)
    2)默认标签解析
      (1)Bean标签解析及注册
         ①BeanDefinitionDelegate类 parseBeanDefinitionElement方法元素解析,返回BeanDefinitionHolder，判断是否存在子节点，
            BeanDefinitionReaderUtils类 generateBeanName Spring命名规则生成对应beanName
              BeanDefinition 实现类RootBeanDefinition/ChildBeanDefinition/GenercBeanDefinition(一站式服务类)
            Bean属性使用及作用：(由parseBeanDefinitionAttributes方法解析)
              scope(默认：singleton)(由AbstractBeanFactory中doGetBean方法进行解析)
              	singleton:单例对象
              	prototype:每次都重新生成一个新的对象给请求方
              	request:XmlWebApplicationContext 会为每个HTTP请求创建一个全新的RequestPrecessor对象，当请求结束后，该对象的生命周期即告结束，如同java web中request的生命周期  	
              singletone
              abstract
              lazy-init 懒加载
              autowire 自动装配模型
              dependency-check 依赖检查
              depends-on 依赖某bean
              autowire-candidate 表示该对象不参与自动注入
              primary 多个同类型的bean实现时，标注为primary 优先级更高
              init-method bean声明周期内，Spring容器Bean初始化时调用的方法
              destroy-method bean声明周期内，Spring容器Bean销毁调用的方法
              factory-bean 通过Spring工厂注入bean，此处为声明工厂bean
              factory-method 通过Spring工厂注入bean，此处为Bean工厂的内部方法
            解析子元素
              meta
                使用：
                  <bean id="myTestBean" class="bean.MyTestBean">
                    <meta key="teststr" value="xxxx"/>
                  </bean>
                作用:
                    记录bean的标签/特性
              lookup-method
                (blog: http://svip.iocoder.cn/Spring/IoC-parse-BeanDefinitions-for-meta-and-look-method-and-replace-method/)
                使用：
                    <bean id="display" class="org.springframework.core.test1.Display">
                        <lookup-method name="method" bean="bean"/>
                    </bean>
                作用：
                    动态方法实现,对某个未实现的方法进行动态实现
              replaced-method
                使用：
                    <bean id="methodReplace" class="org.springframework.core.test1.MethodReplace"/>
                    <bean id="method" class="org.springframework.core.test1.Method">
                        <replaced-method name="display" replacer="methodReplace"/>
                    </bean>
                作用：
                    替换原始方法实现
              constructor-arg(构造函数注入)
                使用：
                    <bean id ="hellobean" class="bean.helloBean" >
                      <constructor-arg index="0">
                        <value>贺政</value>
                      </constructor-arg>
                      <constructor-arg index="1">
                        <value>你好</value>
                      </constructor-arg>
                    </bean>
                作用：
                    配置构造方法的实现
              property
                使用：
                  <bean id = "a">
                    <property name = "p">
                        <list>
                          <value>aaa</value>
                          <value>bbb</value>
                        </list>
                     </property>
                  </bean>
                作用：
                    为属性配置值
              qualifier
                (blog: http://www.voidcn.com/article/p-vdgrbkrm-bqu.html)
                使用：
                  <bean id="myTestBean" class="bean.MyTestBean">
                    <qualifier type="org.Springframework.beans.factory.annotation.Qualifier" value="qf">
                  </bean>
                作用：
                  Spring容器匹配候选Bean当且仅有一个，Spring允许Qualifier指定注入Bean的名称
         ②DefinitionReaderUtils类 registerBeanDefinition 注册

         ③通知相关监听器 Bean已加载完成
         
         
         
         
    创建Bean
        AbstractBeanFactory createBean(抽象方法)
        AbstractAutowireCapableBeanFactory(默认实现createBean)
        
    BeanDefinition    
        [BeanDefinition和BeanFactoryPostProcessor](https://www.processon.com/view/link/5c15e10ae4b0ed122da86303)
        
        
        