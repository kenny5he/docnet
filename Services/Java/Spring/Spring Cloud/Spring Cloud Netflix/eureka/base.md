##### 本地启动Eureka
[官方文档](https://cloud.spring.io/spring-cloud-netflix/reference/html/#spring-cloud-eureka-server)
- 本地单机模式
    ```
        cd ~/workspace/distributed-sys
        java -jar /Users/apaye/workspace/git/eureka-server/target/eureka-server-1.0.0-SNAPSHOT.jar&
    ```
- 集群模式
    - 配置
    ```
        # 服务端口
        server.port=8100
        # eureka 实例主机
        eureka.instance.hostname=localhost
        # eureka注册中心，不注册自己
        eureka.client.register-with-eureka=false
        # 注册中心的职责为维护服务实例，去除检索服务
        eureka.client.fetch-registry=false
        # 提供注册的地址
        # 单体模式下向自己进行服务注册
        eureka.client.service-url.defaultZone=http://${eureka.instance.hostname}:${server.port}/eureka/
        # Spring 服务器名
        spring.application.name=eureka-server
        # Eureka 页面访问地址: http://localhost:8100/
    ```
    - server1
    ```
        java -jar /Users/apaye/workspace/git/eureka-server/target/eureka-server-1.0.0-SNAPSHOT.jar \
             -Deureka.instance.hostname=eureka1.microfoolish.com \
            -Dspring.application.name=eureka-server1 \
            -Dserver.port=8111 \
            -Deureka.client.service-url.defaultZone=http://eureka2.microfoolish.com:8112/eureka/
    ```
    - server2
    ```
        java -jar /Users/apaye/workspace/git/eureka-server/target/eureka-server-1.0.0-SNAPSHOT.jar \
             -Deureka.instance.hostname=eureka2.microfoolish.com \
            -Dspring.application.name=eureka-server2 \
            -Dserver.port=8112 \
            -Deureka.client.service-url.defaultZone=http://eureka1.microfoolish.com:8111/eureka/
    ```
 ##### 源码分析
 