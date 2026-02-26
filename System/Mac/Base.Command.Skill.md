### Mac 命令行信息
#### 端口
##### 根据端口信息查看运行程序信息
```
lsof -i tcp:port
```
##### 查看端口占用情况
```
  netstat -anp
  netstat -anp | grep 8080
```
### PID
#### 根据pid信息查看占用信息
```
lsof -n -P | grep pid
```