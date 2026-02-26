# 安装 Kubernetes
1. 配置 kubeadm、kubelet、kubectl 镜像 repo
```shell
cat > /etc/yum.repos.d/k8s.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
```
2. 安装 kubeadm、kubelet、kubectl
```shell
yum install kubeadm kubectl kubelet --disableexcludes=kubernetes
```
3. 初始化 Kubernetes 集群
```shell
yum install libseccomp -y
systemctl disable firewalld --now
setenforce 0
# 加载 br_netfilter 模块
modprobe br_netfilter
# 允许 iptables 检查桥接流量
echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/ipv4/ip_forward
# 执行预检查操作
kubeadm init phase preflight
# 初始化 kubeadm
kubeadm init --image-repository registry.aliyuncs.com/google_containers --pod-network-cidr=10.21.0.0/16
#
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
# 设置KUBECONFIG环境变量
export KUBECONFIG=/etc/kubernetes/admin.conf
# 查看Node 详情
kubectl describe node
# 默认情况下，Master节点不参与工作负载调度，Master节点作为Node角色
kubectl taint nodes --all node-role.kubernetes.io/master-node/k8s untainted
# 查看污点服务器
kubectl describe nodes|grep Taint
```
5. 配置网络插件
   1. 网络插件选择: https://kubernetes.io/zh/docs/concepts/cluster-administration/addons/
   2. 网络插件: flannel
       1. 下载好flannel的组件镜像
       ```
       crictl pull quay.io/coreos/flannel:v0.14.0
       ```
       2. 获取 flannl 组件 k8s配置
       ```
       curl -O https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
       ``` 
       3. Vagrant 多网卡环境下 flannel 网络插件导致 DNS 无法解析
       ```
       vi kube-flannel.yml
       # - --kube-subnet-mgr 后面加一行参数：参数值为网卡名称
       - --iface=enp1s0
       ```
       4. 部署flannl插件
       ```
       kubectl apply -f kube-flannel.yml
       ```
   3. 网络插件: [Calico](https://www.tigera.io/learn/guides/kubernetes-networking/kubernetes-cni/)
       0. 检查是否存在
       ```
       ls /etc/cni/net.d/*
       ls /opt/cni/bin/flannel
       ls /opt/cni/bin/calico-ipam
       ls /opt/cni/bin/calico
       ```
       1. 获取 calico 组件 k8s 配置
       ```
       curl -O https://projectcalico.docs.tigera.io/v3.22/manifests/calico.yaml
       ```
       2. 修改配置文件
       ```
       CALICO_IPV4POOL_CIDR=10.21.0.0/16
       ```
       3. 部署 [calico.yaml](https://github.com/projectcalico/calico)
       ```
       kubectl apply -f calico.yaml
       ```
6. 检查 Kubernetes 集群是否工作正常
```shell
kubectl get pods --all-namespaces
```
7. 添加 kubernetes nodes 到master
    1. 查看 kubeadm-init.log 令牌信息
    2. 若无 kubeadm-init.log 日志，则检查 token
        ```
        kubeadm token list
        ```
    3. 若无token，则新建 token
        ```
        kubeadm token create
        ```
    4. 查看 discovery token
    ```
     openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
    ```
    5. 加入 node 节点至 admin
       ```
       kubeadm join 192.168.1.105:6443 --token j3g9yl.vn0red8g05yjh85c \
         --discovery-token-ca-cert-hash sha256:352d8e231377d1dfcb2b7f8b3ddd40471f943f83e8eb5bf0dce74bd0cca2e852
       ```
    6. 调整配置文件加入node
    ```shell
    kubeadm config print join-defaults > kubeadm.join.config.yaml
    ```
    7. 将Node加入集群
    ```shell
    kubeadm join --config=kubeadm.join.config.yaml
    ```
8. 使 node节点可运行 kubectl get nodes命令
```shell
# 1. 将 master 中/etc/kubernetes目录中的admin.conf文件 拷贝至 node中同目录
scp /etc/kubernetes/admin.conf root@it211.alphafashion.cn:/etc/kubernetes/
# 2. 设置环境变量
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile
# 使环境变量生效
source ~/.bash_profile
```
9. 设置自启动
```shell
systemctl enable kubelet.service
```
  - 参考博客: https://blog.csdn.net/wucong60/article/details/81455495
10. 参考博客: https://blog.csdn.net/shida_csdn/article/details/108418263