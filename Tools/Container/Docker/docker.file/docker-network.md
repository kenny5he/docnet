



### 疑难问题
1. 网络清理不掉
    1. 查看网络
    ```
    docker network ls
    ```
    2. 查看对应网络详情 
        - 命令
        ```
        docker network inspect rocketmq_default
        ```
        - 结果
        ```
        [
            {
                "Name": "rocketmq_default",
                "Id": "0e8971da7ad26c4b1616f02594b2a328604200fbfd3f93c6a50e8af71912e416",
                "Created": "2023-05-21T01:21:48.4272381Z",
                "Scope": "local",
                "Driver": "bridge",
                "EnableIPv6": false,
                "IPAM": {
                    "Driver": "default",
                    "Options": null,
                    "Config": [
                        {
                            "Subnet": "172.26.0.0/16",
                            "Gateway": "172.26.0.1"
                        }
                    ]
                },
                "Internal": false,
                "Attachable": false,
                "Ingress": false,
                "ConfigFrom": {
                    "Network": ""
                },
                "ConfigOnly": false,
                "Containers": {
                    "4ab7b18ed485a3f03aba303975db8246a1b74aa29eb85fae7e41f9ada87bf1a3": {
                        "Name": "rocketmq-dashboard",
                        "EndpointID": "5a2ee340b344e2228364d331e9f2604814ceaefbb7d65a4248ddb88c9c902c2b",
                        "MacAddress": "02:42:ac:1a:00:03",
                        "IPv4Address": "172.26.0.3/16",
                        "IPv6Address": ""
                    }
                },
                "Options": {},
                "Labels": {
                    "com.docker.compose.network": "default",
                    "com.docker.compose.project": "rocketmq",
                    "com.docker.compose.version": "2.2.1"
                }
            }
        ]
        ```
    3. 断连网络，删除网络
        - 命令
        ```
        docker network disconnect -f rocketmq_default rocketmq-dashboard
        ```
        - 入参释义(第二步结果中的信息)
            - rocketmq_default: Network Name
            - rocketmq-dashboard: Containers Name