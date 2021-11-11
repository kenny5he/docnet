1.将服务提供者注册到注册中心（暴露服务）
    1.1 导入dubbo依赖、zookeeper客户端
        <!-- Dubbo -->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>dubbo</artifactId>
            <version>2.6.5</version>
        </dependency>

        <!-- Zookeeper -->
        <dependency>
            <groupId>org.apache.curator</groupId>
            <artifactId>curator-framework</artifactId>
            <version>4.1.0</version>
        </dependency>
    1.2
        provider.xml
2.服务消费者到注册中心获取服务提供者的信息
    cunsumer.xml

3.SpringBoot

    1.启动类(自动扫描Dubbo注解)
        @EnableDubbo
    2.服务方
        配置:
            dubbo:
              application:
                name: microfoolish-provider
              registry:
                protocol: zookeeper
                address: 127.0.0.1
                port: 2181
              protocol:
                name: dubbo
                port: 20880
              monitor:
                protocol: registry
        注解:
            @Service(Dubbo提供的注解，非Spring提供的)
    3.调用方
        配置:
            dubbo:
              application:
                name: microfoolish-consumer
              registry:
                protocol: zookeeper
                address: 127.0.0.1
                port: 2181
              monitor:
                protocol: registry
        注解:
            @Reference(远程过程调用)

4.配置优先级关系
    1. 越精确越优先
    2. 级别一致情况下，消费方配置优先，服务方次之。

5.高可用
    zookeeper宕机与dubbo直连
    1. 监测中心宕机不影响使用，至少丢失部分采样数据
    2. 数据库宕机后，注册中心仍能通过缓存提供服务列表信息查询，但不能注册新服务
    3. 注册中心等集群，任意一台宕机后，将自动切换到另一台(Zookeeper特性，woker flower切换)
    4. 注册中心全部宕机后，服务提供者和服务消费者仍能通过本地缓存通讯
    5. 服务提供者无状态，任意一台宕机后不影响使用
    6. 服务提供者全部宕机后，服务消费者应用将无法使用，将无限次重连等待服务提供者恢复
6.负载均衡
    1. Randon LoadBalance 随机，按权重设置随机概率(设置权重weight)
    2. RoundRobin LoadBalance 轮询，按公约后的权重设置轮询比率
    3. LeatsActive LoadBalance 最少活跃数，相同活跃数随机(活跃数是指调用前后计数差)
    4. ConsistentHash LoadBalance 一致性Hash 相同参数请求总是分发到同一个提供者

7.服务降级
    什么是服务器降级?
        当服务器压力剧增的情况下，根据实际业务情况及流量，对一些服务和页面有策略的不处理或换种简单的方式处理，从而释放服务器资源以保证核心交易正常运作或高效运作
    手段:
        mock=before:return+null 强制返回为空
        mock=fail:return+null 消费者对该服务方法调用失败后
8.集群容错
