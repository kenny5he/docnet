## Kubernetes Dashboard
1. 获取脚本
```shell
wget -O kubernetes-dashboard.yaml https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
```
2. 修改镜像源
```shell
sed -i 's#kubernetesui/dashboard#registry.cn-hangzhou.aliyuncs.com/k8sos/dashboard#g' kubernetes-dashboard.yaml
sed -i 's#kubernetesui/metrics-scraper#registry.cn-hangzhou.aliyuncs.com/k8sos/metricsscraper#g' kubernetes-dashboard.yaml
```
3. 检查镜像源地址:
```shell
cat recommended.yaml | grep image
```
4. 执行脚本
```shell
kubectl proxy
```
3. Access Dashboard
```shell
kubectl proxy
```
4. Authentication Token (RBAC)
```
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
```
- 官方Github: https://github.com/kubernetes/dashboard#kubernetes-dashboard