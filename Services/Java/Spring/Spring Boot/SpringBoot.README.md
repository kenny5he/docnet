##### Spring Boot Demo
- [访问路径](http://localhost:8585/microfoolish)

##### 配置文件
- bootstrap.properties
- application.properties

##### 调用链原理
1. SpringApplication.run
    - 准备参数、初始化环境信息Environment、打印Banner信息
    - 判断应用上下文,创建Spring容器(ApplicationContext)
        - Default Context -> org.springframework.context.annotation.AnnotationConfigApplicationContext
        - Servlet(WebMVC) -> org.springframework.boot.web.servlet.context.AnnotationConfigServletWebServerApplicationContext
        - Reactive(WebFlux)(响应式编程) -> org.springframework.boot.web.servlet.context.AnnotationConfigServletWebServerApplicationContext
    - prepareContext 调用所有初始化类的initialize 方法
    - refreshContext 初始化 Spring 容器。
        - (applicationContext).refresh()
            - AbstractApplicationContext.refresh
                - AbstractApplicationContext.postProcessBeanFactory
                - AbstractApplicationContext.registerBeanPostProcessors
                - AbstractApplicationContext.onRefresh
                    - ServletWebServerApplicationContext继承GenericWebApplicationContext调用refresh方法
                        - ServletWebServerApplicationContext.createWebServer 
                            - ServletWebServerFactory 获取Tomcat/Jetty
                            - TomcatServletWebServerFactory.getWebServer 初始化Tomcat,初始化端口，初始化Tomcat BasePath(临时目录)
                - AbstractApplicationContext.finishBeanFactoryInitialization
                - AbstractApplicationContext.finishRefresh
                    - ServletWebServerApplicationContext继承GenericWebApplicationContext调用finishRefresh方法
                        - ServletWebServerApplicationContext.startWebServer 启动Tomcat
    - afterRefresh 调用后置逻辑


##### Servlet 3.x
 SpringServletContainerInitializer
 
##### Spring Boot官方文档
https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-documentation