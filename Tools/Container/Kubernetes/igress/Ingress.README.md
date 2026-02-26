## [Network Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
1. 获取Ingress 信息
```shell
kubectl get ingress -n apps
```


### Gray Deploy (灰度发布)
- 解释: 应用部署测试完成后，完全将全部流量切换到新部署的应用服务器上

### Blue Deploy (蓝绿发布)
- 解释: 应用部署测试完成后，将部分用户(例: 20%)切换至部署后的应用服务器上，并监测新切换到应用的(例:20%)用户服务接口、内存CPU负载、日志错误信息及运营手段 判断是否存在功能BUG。待无Bug后，将全部流量切换至新部署的应用。
