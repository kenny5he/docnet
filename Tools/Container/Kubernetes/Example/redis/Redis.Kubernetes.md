## Redis
### Redis 集群部署
1. 执行 redis-cluster.yaml
2. redis 加入集群
```shell
kubectl exec -it redis-cluster-0 -- redis-cli --cluster create --cluster-replicas 1 $(kubectl get pods -l name=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379')
```

- 参考简书: https://www.jianshu.com/p/c719d3fae027
- 参考博客: https://www.cnblogs.com/obitoma/p/14547336.html