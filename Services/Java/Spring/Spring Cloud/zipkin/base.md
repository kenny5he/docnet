## 定义
Zipkin是Twitter的开源项目，它基于Google Dapper实现，一般使用它收集各个服务器上请求链路的跟踪数据，并通过它提供的REST API接口辅助查询跟踪数据以实现对分布式系统的监听程序。从而及时发现系统中出现的延迟升高问题并找出系统性能瓶颈的根源。
### 核心组成
- Collector: 收集器组件
- Storage: 存储组件
- Restful API: API组件
- Web UI: UI组件

## 应用
### 搭建Zipkin Server
1. 集成zipkin jar包
```xml
<dependency>
    <groupId>io.zipkin.java</groupId>
    <artifactId>zipkin-server</artifactId>
</dependency>
<dependency>
    <groupId>io.zipkin.java</groupId>
    <artifactId>zipkin-autoconfigure-ui</artifactId>
</dependency>
```
2. 主类添加 @EnableZipkinServer注解

### 应用端集成zipkin
1. 集成jar包
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-sleuth-zipkin</artifactId>
</dependency>
```
2. 配置zipkin服务地址
```property
spring.zipkin.base-url=http://zipkin.url
```
### 集成消息中间件收集
1. 应用端集成rabbit
- jar包集成
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-sleuth-stream</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-sleuth-rabbit</artifactId>
</dependency>
```
- rabbit属性配置
```
spring.rabbitmq.host=
spring.rabbitmq.port=
spring.rabbitmq.username=
spring.rabbitmq.password=
```
2. 应用端集成kafka
- jar包集成
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-sleuth-stream</artifactId>
</dependency>
<dependency>  
    <groupId>org.springframework.cloud</groupId>  
    <artifactId>spring-cloud-starter-stream-kafka</artifactId>  
</dependency>  
```

- kafka属性配置
spring.cloud.stream.kafka.binder.brokers=
spring.cloud.stream.kafka.binder.zkNodes=
3. 应用端集成rabbit
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-sleuth-stream</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-sleuth-rabbit</artifactId>
</dependency>
<dependency>
    <groupId>io.zipkin.java</groupId>
    <artifactId>zipkin-autoconfigure-ui</artifactId>
</dependency>
```