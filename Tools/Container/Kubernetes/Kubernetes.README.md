## K8s 使用文档
[Install](https://kubernetes.io/zh/docs/tasks/tools/install-kubectl-linux/)

### Kubernetes基本概念及术语: 
1. Service服务
    1. Service服务是分布式集群架构的核心
    2. Service服务特征
       - 拥有一个唯一指定的名字
       - 拥有一个虚拟IP(Cluster IP、Service IP或VIP)和端口
       - 能够提供某种远程服务能力
       - 被映射到了提供这种服务能力的一组容器应用上
2. Master结点: Kubernetes的集群控制点，负责控制命令具体执行，
    1. 关键进程：
        1. Kubernetes API Server: Rest接口的关键服务进程，资源增、删、改、查等操作的唯一入口，集群控制的入口进程
        2. Kubernetes Controller Manager: 所有资源对象的自动化控制中心
        3. Kubernetes Scheduler: 负责资源调度(Pod调度)的进程
        4. etcd 进程: 保存所有资源对象的数据
3. Node(工作节点)
    1. 关键进程
        1. kubelet: 负责Pod对应容器的创建、启停等,与Master协作集群管理的基本功能
        2. kube-proxy: 实现通信与负载均衡机制
4. Pod: 在Node上Kubernetes管理的最小运行单元
    1. Pod类型: 普通Pod、静态Pod(Static Pod)(不存在etcd存储里，存放在Node上的具体文件中)
    2. Pod的作用: 
       1. 通过引入与业务无关的Pause容器作为Pod的根容器，以它的状态代表整个容器组的状态，容器健康检查
       2. Pod多业务容器共享Pause容器IP、Volume，简化业务容器的通信及文件共享问题。
    3. Pause: 根容器(gcr.io/google_containers/pause-amd64)
    4. Replication Controller (RC): Service 扩容
        1. RC的定义:
            1. 目标Pod的定义
            2. 目标Pod需要运行副本的数量(Replicas)
            3. 监控的目标Pod的标签(Label)
        2. RC的命令
            1. 动态缩放Pod(动态扩容)
            ```shell
            kubectl scale rc mysql-rc --replicas=3
            ```
    
- 虚拟机方式: https://minikube.sigs.k8s.io/docs/getting-started/macos/
- k8s中文官网: https://www.kubernetes.org.cn/page/5?s=kube-controller-manager
