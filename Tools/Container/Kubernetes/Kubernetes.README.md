##### K8s 使用文档
[官方文档](https://kubernetes.io/docs/imported/release/notes/)
[Install](https://kubernetes.io/zh/docs/tasks/tools/install-kubectl-linux/)

###### Kubernetes基本概念及术语: 
1. Master:Kubernetes的集群控制点，负责控制命令具体执行，
    1. 关键进程：
        1. Kubernetes API Server: 资源增、删、改、查等操作的唯一入口，集群控制的入口进程
		2. Kubernetes Controller Manager: 所有资源对象的自动化控制中心
		3. Kubernetes Scheduler: 负责资源调度(Pod调度)的进程
		4. etcd 进程: 保存所有资源对象的数据


- 虚拟机方式: https://minikube.sigs.k8s.io/docs/getting-started/macos/
- k8s中文官网: https://www.kubernetes.org.cn/page/5?s=kube-controller-manager
