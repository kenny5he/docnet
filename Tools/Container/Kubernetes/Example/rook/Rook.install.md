## 安装Rook
1. 下载Rook源码
```shell
git clone https://github.com/rook/rook.git
```
2. 部署 Admission Controller (Rook准入器，确保自定义资源设置正确的Rook)
```shell
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.15.3/cert-manager.yaml
```
3. 部署 Rook Operator
```shell
# 将目录移至 rook 的案例目录
cd rook/deploy/examples

kubectl apply -f crds.yaml -f common.yaml -f operator.yaml
```
4. 查看operator 是否运行
```shell
kubectl get pods -n rook-ceph
```
5. 部署 Rook Ceph
    1. 配置 cluster.yaml
        ```
          # 在 k8s 之外使用ceph，由主机ip 提供服务
          provider: host
        
          # 查看硬盘 lsblk 情况
          # 加入硬盘
          storage: 
            nodes:
              - name: "k8s-node002.microfoolish.com"
                devices: 
                - name: "sdb"
              - name: "k8s-node002.microfoolish.com"
                devices: 
                - name: "sdb"
              - name: "k8s-node003.microfoolish.com"
                devices: 
                - name: "sdb"
        ```
    2. 创建 ceph 集群
        ```shell
        kubectl apply -f cluster.yaml
        ```
    3. 查看pod运行情况
        ```shell
        kubectl get pods -n rook-ceph
        ```
6. 部署 Toolbox
   ```shell
   kubectl apply -f toolbox.yaml
   ```