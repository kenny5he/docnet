# Crictl

## Crictl 与 Docker 命令对比
| Containerd 命令 |  Docker 命令 | 备注 |
|--- | --- | --- |
|ctr image ls| docker images | 获取镜像信息 |
|ctr image pull pause | docker pull pause | 拉取 pause 镜像 |
|ctr task ls | docker ps | 查看运行的容器 |