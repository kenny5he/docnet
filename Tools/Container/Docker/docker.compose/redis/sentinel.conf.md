### 哨兵模式说明
- 作用
    - 监控：哨兵不断的检查master和slave是否正常的运行。
    - 通知：当监控的某台Redis实例发生问题时，可以通过API通知系统管理员和其他的应用程序。
    - 自动故障转移：如果一个master不正常运行了，哨兵可以启动一个故障转移进程，将一个slave升级成为master，其他的slave被重新配置使用新的master，并且应用程序使用Redis服务端通知的新地址。
    - 配置提供者：哨兵作为Redis客户端发现的权威来源：客户端连接到哨兵请求当前可靠的master的地址。如果发生故障，哨兵将报告新地址。
- 配置
    - logfile "sentinel.log"：输出日志目录
    - sentinel monitor mymaster 192.168.0.1 6379 1：哨兵监控的主服务器名称为mymaster，ip为192.168.0.1，端口为6379，将这个主服务器标记为失效至少需要1个哨兵进程的同意
    - sentinel auth-pass mymaster 1234 ： 哨兵的认证密码

```shell script
sudo docker run -p 26379:26379 -v /data/redis_data/:/data --name redis-26379 -d docker.io/redis redis-sentinel sentinel.conf
```