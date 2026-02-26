## Jenkins
### Jenkins 安装
1. 应用 jenkins 
```shell
kubectl apply -f jenkins.yaml
```
2. 检查jenkins状态
```shell
# 获取 devops pod 信息 
kubectl get pods -n devops 
# 获取 devops 部署信息
kubectl get deployment -n devops
# 检查 pvc 信息
kubectl get pvc -n devops
# 查询pod 详细信息
kubectl describe pod jenkins-7cfdfc7df7-wsb7s -n devops
# 查看pod 日志
kubectl logs -f jenkins-7cfdfc7df7-wsb7s 
```

- 参考: https://tech.souyunku.com/?p=41610