# [Helm](https://helm.sh/)
Helm 帮助您管理 Kubernetes 应用—— Helm Chart，即使是最复杂的 Kubernetes 应用程序，都可以帮助您定义，安装和升级。

### 安装 Helm
1. 通过 Shell 脚本命令安装 Helm
```shell
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 777 get_helm.sh
./get_helm.sh
```
2. 下载安装
    1. [下载压缩包](https://github.com/helm/helm/releases)
    ```shell
    curl -O https://get.helm.sh/helm-v3.8.0-linux-386.tar.gz
    ```
    2. 解压
    ```shell
    tar -zxvf helm-v3.8.0-linux-386.tar.gz
    ```
    3. 移动至运行目录
    ```shell
    mv linux-amd64/helm /usr/local/bin/helm
    ```
3. 直接运行安装
```shell
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```
### Helm 使用
1. 添加稳定仓库
    1. 例: 添加 rancher 仓库
    ```shell
    helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
    ```
    2. 例: 添加 jetstack 仓库
    ```shell
    helm repo add jetstack https://charts.jetstack.io
    ```





