## Service
- Kubernetes的service有三种类型：ClusterIP，NodePort，LoadBalancer,
- Kubernetes 主要包含两种IP，分别是Pod IP和Cluster IP。 Pod IP是实际存在于网卡之上（如VETH的虚拟网卡），而Cluster IP则是一个虚拟的IP地址，
该虚拟机IP由kube-proxy进行维护，kube-proxy目前提供了两种实现方式，包括默认的ip tables实现以及在K8S 1.8之后开始支持的ipvs实现。

### ClusterIP: (提供一个集群内部的虚拟IP以供Pod访问)


### NodePort: (Node 端口供外部访问)


### LoadBalancer: (通过外部的负载均衡器来访问)



- 参考文章: https://www.imooc.com/article/275693
- 参考文章: https://www.imooc.com/article/39964