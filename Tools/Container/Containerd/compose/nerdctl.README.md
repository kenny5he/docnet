# Containerd NERDCTL
1. 启动所有服务
```shell
nerdctl compose up -d
```
2. 查看服务状态
```shell
nerdctl compose ps
```
3. 查看日志
```shell
nerdctl compose logs -f
```
4. 停止服务
```shell
nerdctl compose down
```