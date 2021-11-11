## [SPI](https://www.cnblogs.com/lovesqcc/p/5229353.html)
1. 概念: Service Provider Interface : 服务提供接口
2. SPI的作用?
3. SPI实现: 通过ServiceLoader 实现迭代Interable接口，循环加载META-INF/services目录下的文件，通过Classloader加载相应类实现。
4. 常见SPI的扩展实现:
    - Mysql
      - SPI接口定义类: java.sql.Driver(Interface)
      - SPI接口 java.sql.Driver 实现类: mysql实现(mysql-connector-java.jar): META-INF/services/java.sql.Driver文件(j文件内指定值com.mysql.jdbc.Driver)

## spring.factories
- 实现与SPI类似
- 实现:
    - spring-core包里定义了SpringFactoriesLoader类，这个类实现了检索META-INF/spring.factories文件，并获取指定接口的配置的功能,
    - loadFactories方法 根据接口类获取其实现类的实例，这个方法返回的是对象列表。
    - loadFactoryNames方法 根据接口获取其接口类的名称，这个方法返回的是类名的列表。
