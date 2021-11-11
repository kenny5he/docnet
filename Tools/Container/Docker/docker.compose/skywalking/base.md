### Docker-Compose 安装
参考: https://blog.csdn.net/cast_lzl/article/details/115806066

### Agent 设置
1. VM Operation
```
-javaagent:/opt/apache/skywalking/apache-skywalking-apm-es7/agent/skywalking-agent.jar
```
2. Environment
```

SW_AGENT_NAME=openapi-gateway;SW_AGENT_COLLECTOR_BACKEND_SERVICES=127.0.0.1:11800
```


### 查看docker 信息
docker exec -it elasticsearch-sky /bin/bash