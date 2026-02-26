## Kube Adm
1. 初始化 kubeadm
```shell
kubeadm init --image-repository registry.aliyuncs.com/google_containers --pod-network-cidr=10.21.0.0/16
```

2. 重置 kubeadm
    1. 检查是否拥有正在运行的pod，有运行的非系统apiserver/etcd/ 立即停止
    ````shell
    kubectl get pods --all-namespaces -o wide
    ````
    2. 重置
    ```
    kubeadm reset
    ```
    3. 删除$HOME目录中的 管理文件
    ```shell
    rm -rf $HOME/.kube
    ```
    4. 重启 kubectl 程序
    ```shell
    systemctl daemon-reload && systemctl restart kubelet
    ```
    5. 重新执行kubeadm 初始化过程