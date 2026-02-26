# [Rancher](https://rancher.com/docs/rancher/v2.6/en/)
1. [安装 Ingress Nginx](workspace/git/worknotes/docnet/Tools/Container/Kubernetes/igress/Ingress.Nginx.README.md)
2. [安装 Helm](workspace/git/worknotes/docnet/Tools/Container/Kubernetes/Helm.md)
3. 安装 Cert-Manager
    1. 下载配置文件(v1.7.1)
    ```
    https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.crds.yaml
    ```
    2. 修改配置
    ```shell
      
    ```
    3. 应用 Cert-Manager
    ```shell
    kubectl apply -f cert-manager.crds-v1.5.1.yaml
    ```
    4. 添加Helm源
    ```shell
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    ```
    5. 通过 Helm 安装
    ```shell
    helm install cert-manager jetstack/cert-manager \
      --namespace cert-manager \
      --create-namespace \
      --version v1.5.1
    ```
    6. 检查/查看 Cert-Manager
    ```shell
    kubectl get pods --namespace cert-manager
    ```
4. 安装 Rancher
    1. 创建命名空间
    ```shell
    kubectl create namespace cattle-system
    ```
    2. 安装
    ```shell
    helm install rancher rancher-stable/rancher \
      --namespace cattle-system \
      --set hostname=rancher.alphafashion.cn \
      --set bootstrapPassword=a#AF%rpl1qefN
    ```

- 参考: https://zhuanlan.zhihu.com/p/465017157