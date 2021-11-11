#### Redis配置说明
- dir：工作目录
- logfile：日志文件在工作目录下
- slaveof：指明为主机一的从机
- requirepass：redis客户端连接的认证密码，若不需要可不配置
- masterauth：主从redis同步的认证密码，与连接密码同，若不需要可不用配置
- appendonly：是否需要持久化，yes为需要

```shell script
sudo docker run -p 6379:6379 -v /data/redis_data/:/data --name redis-6379 -d docker.io/redis redis-server redis.conf
```

#### 参考
- [Redis 集群参考博客](https://www.cnblogs.com/hutao722/p/9644620.html)
- [Redis Docker Compose 参考博客](https://blog.csdn.net/qq_39211866/article/details/88044546)

#### 连接
./opt/redis/redis-5.0.5/src/redis-cli -p 63791 -a rdsdmt.123