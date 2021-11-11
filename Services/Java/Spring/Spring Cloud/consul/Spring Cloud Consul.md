### Consul Document
1. https://www.consul.io/docs




### Spring Cloud Consul
#### Configuration
1. ConsulAutoServiceRegistration
2. ConsulAutoRegistration
    1. 设置Env、Group、Zone 等进行分区，本地环境与测试环境隔离，开发人员与开发人员隔离
        1. 设置 Group
        2. 设置 Zone
        3. 设置 Tags
            1. ConsulDiscoveryProperties
            ```properties
            spring.cloud.consul.discovery.tags
            ```
   2. 设置注册链接认证
       1. ConsulDiscoveryProperties
           ```properties
           spring.cloud.consul.token=
           ```