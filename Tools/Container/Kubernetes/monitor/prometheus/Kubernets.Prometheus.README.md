## Prometheus
### 安装 Prometheus
1. 安装GIT
```
yum -y install git
```
2. 下载 Kubernetes 与 Prometheus
```
git clone https://github.com/coreos/kube-prometheus.git
# kubectl : Too long: must have at most 262144 bytes
git clone --branch v0.9.0 https://github.com/prometheus-operator/kube-prometheus.git
```
3. 修改配置端口
   1. Grafana
   ```
   
   ```
   2. AlertManager
   ```
   
   ```
   3. Prometheus
   ```
   
   ```
4. Kubernetes Cli
    1. Step
        ```
        1. 确认目录
        /root/kube-prometheus/manifests
        2. 执行
        kubectl apply -f setup/
        ```
    2. manifests
        ```
        1. 确认目录
        /root/kube-prometheus
        2. 执行
        kubectl apply -f manifests/
        ```
    3. 检查
    ```
    1. pod monitor
    kubectl get pod -n monitoring
    2. grafana
    kubectl get svc -n monitoring | grep grafana
    3. node monitor
    kubectl top node
    ```
    4. 登录 grafana
    ```
    user=admin
    password=admin
    changepassword=
    ```
    - 参考: https://blog.csdn.net/weixin_44907813/article/details/108219138
#### 安装报错分析
1. The CustomResourceDefinition "prometheuses.monitoring.coreos.com" is invalid: metadata.annotations: Too long: must have at most 262144 bytes
    1. 报错信息:
    ```
    The CustomResourceDefinition "prometheuses.monitoring.coreos.com" is invalid: metadata.annotations: Too long: must have at most 262144 bytes
    ```
    2. 错误原因: https://github.com/prometheus-operator/kube-prometheus/issues/1511
    ```
    
    ```
2. Error from server (ServiceUnavailable): the server is currently unable to handle the request (get nodes.metrics.k8s.io)
   1. 报错信息: 
   ```
   Error from server (ServiceUnavailable): the server is currently unable to handle the request (get nodes.metrics.k8s.io)
   ```
   2. 错误原因: https://github.com/prometheus-operator/kube-prometheus/issues/505
   ```
   1. 查看 metrics 详情
   kubectl describe apiservice v1beta1.metrics.k8s.io
   2. 查看 metrics pod 状态
   kubectl get pods -A|grep metrics
   3. 查看 metrics 日志
   kubectl logs -n monitoring kube-state-metrics-5c5d68c99d-w6qg4
   ```