## 镜像代理
- Kubernetes Ingress Nginx: https://github.com/kubernetes/ingress-nginx/issues/6335
### 阿里云


### Azure Cloud
> Note: currently *.azk8s.cn could only be accessed by Azure China IP, we don't provide public outside access any more. If you have such requirement to whitelist your IP, please contact akscn@microsoft.com, provide your IP address, we will decide whether to whitelist your IP per your reasonable requirement, thanks for understanding.
- 不支持公网Ip 访问，只支持 Azure China IP
- 参考: https://github.com/Azure/container-service-for-azure-china/blob/master/aks/README.md

### Self 
1. 登录代理服务器下载镜像
```shell
docker pull k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
docker pull k8s.gcr.io/ingress-nginx/controller:v1.1.1
```
2. 查看镜像
```shell
docker images | grep ingress-nginx 
```
3. 打包镜像
```shell
docker save ef43679c2cae -o /root/ingress-nginx-controller_v1.1.1.tar
docker save 17e55ec30f20 -o /root/ingress-nginx-kube-webhook-certgen_v1.1.1.tar
```
4. 导入到国内服务器
```shell
docker load -i ingress-nginx-controller_v1.1.1.tar
docker load -i ingress-nginx-kube-webhook-certgen_v1.1.1.tar
```
5. 镜像重命名打TAG
```shell
docker tag ef43679c2cae k8s.gcr.io/ingress-nginx/controller:v1.0.0
docker tag 17e55ec30f20 k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.0
```