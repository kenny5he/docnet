## Install Ingress Nginx
1. 获取脚本
```shell
# Cloud
wget -O nginx-gray-ingress-old.yaml https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/cloud/deploy.yaml
# 裸机
wget -O nginx-gray-ingress-old.yaml https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/baremetal/deploy.yaml
```
2. 根据 镜像名至阿里云 [aliyun images](https://cr.console.aliyun.com/cn-hangzhou/instances/images) 搜索相关镜像信息
3. 检查网络
```shell
https://viewdns.info/chinesefirewall/?domain=gcr.io
```
4. 拉取镜像
```shell
crictl pull registry.aliyuncs.com/google_containers/kube-webhook-certgen:v1.1.1
crictl pull registry.aliyuncs.com/google_containers/nginx-ingress-controller:v1.1.1
```
5. 修改 nginx-ingress 镜像文件
```
# 修改镜像地址为 aliyun 镜像
```
6. 执行脚本
```shell
kubectl apply -f nginx-gray-ingress-old.yaml
```
7. 检查 (Pre-flight check)
```shell
# 检查 pod 
kubectl get pods --namespace=ingress-nginx
# 检查 secret
kubectl get secret --namespace ingress-nginx
```
8. 检查日志
```shell
kubectl describe pod ingress-nginx-admission-create-qgzvs -n ingress-nginx
```
## Config Nginx Ingress
1. 调整配置Nginx Ingress端口
```
spec:
  type: NodePort # 调整点
  ipFamilyPolicy: SingleStack
  ipFamilies:
    - IPv4
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: http
      nodePort: 30080 # 调整点
      appProtocol: http
    - name: https
      port: 443
      protocol: TCP
      nodePort: 30443 # 调整点
      targetPort: https
      appProtocol: https
```
2. 调整Nginx上传下载，文件限制
```
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    helm.sh/chart: ingress-nginx-4.0.15
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 1.1.1
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: controller
  name: ingress-nginx-controller
  namespace: ingress-nginx
data:
  allow-snippet-annotations: 'true'
  proxy-body-size: 50m    # 调整点
```
  -参考: https://www.cnblogs.com/pythonPath/p/11526191.html



- 阿里云Ingress-Nginx: https://github.com/aliyuncontainerservice/ingress-nginx
- 阿里云案例: https://www.alibabacloud.com/help/zh/doc-detail/86533.htm