## Node
1. 给节点添加标签
```shell
kubectl label nodes it10.alphafashion.cn core=4
kubectl label nodes it211.alphafashion.cn core=2
kubectl label nodes it105.alphafashion.cn core=4
```
2. 查看节点标签
```shell
kubectl get nodes --show-labels
```

