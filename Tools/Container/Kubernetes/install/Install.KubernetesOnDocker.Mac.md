# Install Kubernetes 

## install exception:
1. warring info: 1. kuberates is starting( 一直在启动中，卡住 )
    - resovle :(国内网络环境，导致无法拉取或极慢拉取所需镜像)
    1. 拉取git库
        ```
        git clone https://github.com/maguowei/k8s-docker-for-mac.git
        ```
    2. 运行脚本
        ```
        cd k8s-docker-for-mac
        ./load_images.sh
        ```
    3. 重启kubernetes

2. warring info: Error response from daemon, No such image
    ```
       error pulling image configuration: Get https://production.cloudflare.docker.com/registry-v2/docker/registry/v2/blobs/sha256/ac/ac2ce44462bce3f3ab9e8c4bd0457da1107849fb5f0a7ced346e610939f7a4fe/data?verify=1565600414-Kgg%2BUgymtVrcRYkuAXVDg9LmFOY%3D: net/http: TLS handshake timeout
       Error response from daemon: No such image: gotok8s/kube-controller-manager:v1.14.3
       Error: No such image: gotok8s/kube-controller-manager:v1.14.3
   ```
   - Resovle : 重新执行脚本

3. 运行dashboard:
    - kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
    - kubectl proxy #默认情况下代理的是8001端口，如果要指定端口用下面命令
    - kubectl proxy --port=8080

4. 我们采用令牌的方式进行登录，首先创建管理员角色，k8s-admin.yaml的文件
    - 在命令行中进入到k8s-admin.yaml文件所在目录，执行下面命令添加管理员角色
    ```
        kubectl create -f k8s-admin.yaml
    ```
5. 获取管理员角色的secret名称
    ```
    kubectl get secret -n kube-system
    ```
4.获取token值
    ```
    kubectl describe secret dashboard-admin-token-tc5wk -n kube-system
    ```
5. 将登陆界面切换到令牌的模式，上图中的token值粘贴到令牌输入框中，点击登录可以进入到管理界面
6. 访问http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login
