1. 添加 Node至集群
   1. 命令行添加Node 至集群
    ```shell
    kubeadm join 192.168.1.105:6443 --token hi6auw.u73ecok6ygx68lwf \
    --discovery-token-ca-cert-hash sha256:096b7e53385070d9b59d484865b2fe24c5fdc375d8e5375f70e9e8f4d370c80b
    ```
    2. copy to node admin config
    ```
    scp /etc/kubernetes/admin.conf root@it10.alphafashion.cn:/etc/kubernetes
    ```
    3. setting env (vi ~/.bash_profile)
    ```shell
    export KUBECONFIG=/etc/kubernetes/admin.conf
    ```
2. 将Node 从集群中移除
```shell
kubeadm reset
```
