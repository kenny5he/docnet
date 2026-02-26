##Kubernetes Secret
1. 列出所有 Secret 信息
```shell
kubectl get secret
```
2. 查看 Secret 信息
```shell
# 查看名为 dashboard-admin-token-kkdj9, namespace 为 kube-system 的 Secret信息
kubectl describe secret dashboard-admin-token-kkdj9 -n kube-system
```
