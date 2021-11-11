## Tomcat 相关问题
### Tomcat Web容器
1. War包与Jar包，主要用于区分是否为Web项目，主要区别jar包只是单纯作为依赖。
2. Tomcat 中拥有三种部署方式，在类org.apache.catalina.startup.HostConfig中deployApps方法定义
    1. 描述符部署(deployDescriptors)(context标签中添加 path属性与值、docBase属性与值)(iCare7的本地编译部署方式)
    2. War包部署(deployWARs)
    3. 文件夹部署(deployDirectories)
3. 
### Tomcat 类加载顺序
1. $java_home/lib 目录下的java核心api
2. $java_home/lib/ext 目录下的java扩展jar包
3. java -classpath/-Djava.class.path所指的目录下的类与jar包
4. $CATALINA_HOME/common目录下按照文件夹的顺序从上往下依次加载
5. $CATALINA_HOME/server目录下按照文件夹的顺序从上往下依次加载
6. $CATALINA_BASE/shared目录下按照文件夹的顺序从上往下依次加载
7. 我们的项目路径/WEB-INF/classes下的class文件
8. 我们的项目路径/WEB-INF/lib下的jar文件

### Tomcat整体架构和处理流程分析

### Tomcat7设置为NIO模型
```
<Connector port="8080" protocol="org.apache.coyote.http11.Http11NioProtocol" connectionTimeout="20000" redirectPort="8443"/>
```

### Tomcat中关于长连接的底层原理与源码实现
1. 长连接是什么？
    - 请求头中存在: Connection: keep-alive
    - Tomcat 在接受请求后，Socket暂时未关闭，等待下一次请求，等待达到设置机制后，再去关闭Socket。
    - Http11Processor类中disableKeepAlive方法，如果活跃的线程数占线程池最大线程数的比例大于75%，则关闭KeepAlive,
    
### Tomcat中自定义类加载器的使用与源码实现

### Tomcat请求处理详解

### Tomcat启动过程

### Tomcat中Session功能的实现

### Tomcat中JSP的功能实现

### Tomcat 如何加载Jar包及Jar包中的类

### Tomcat 如何加载Servlet

### Tomcat 中Catalina的作用
