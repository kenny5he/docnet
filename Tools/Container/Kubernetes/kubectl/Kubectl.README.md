# Kubectl (Kubernetes客户端命令行工具)
## Kubernetes Ctl 命令

| 命令 | 命令格式 | 说明 | Example |
| --- | --- | --- | ---|
| get |  |  |  |
| exec | kubectl exec -n devops -it jenkins-7cfdfc7df7-cjnzm -- /bin/bash |  |  |
| delete |  |  |  |
| create |  |  |  |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |

### Nodes 工作节点信息
1. 查看nodes信息
```shell
kubectl get nodes
```
2. 查看node详情
```shell
kubectl describe nodes
```
### Pod 运行单元信息
1. 查看pod 信息
```
   kubectl get pods
```
2. 查看
```
   kubectl get pods -n kube-system
```
3. 查看pod网络信息
```
   kubectl get pods -o wide --all-namespaces
```
4. 查看pod
```shell
kubectl top pods
```
5. 删除pod
```shell
# nginx 为 pod 名
kubectl delete po nginx
```
### SVC 网络信息
1. 查看网络信息
```
kubectl get svc -o wide
```

### CS 信息
1. 获取 CS信息
```
kubectl get cs
```

### NameSpace信息
1. 获取 NameSpace 信息
```
kubectl get ns
```
2. 创建 NameSpace
```shell
kubectl create namespace devops
```
### Deployment 部署信息
1. deployment (部署信息)
```
kubectl get deployment
```
### APIService
1. 查看 apiservice 运行信息
```shell
kubectl get apiservice
```
2. 删除指定的 apisevice
```shell
kubectl delete apiservice v1beta1.metrics.k8s.io
```
### 查看集群运行情况
1. 查看 Cluster 信息
```
kubectl cluster-info
# 查看dump 信息
kubectl cluster-info dump
```
2. 查看Kubectl 状态
```shell
systemctl status kubelet.service
```
3. 查看systemd中 kubelet的信息
```shell
journalctl -xefu kubelet
```
