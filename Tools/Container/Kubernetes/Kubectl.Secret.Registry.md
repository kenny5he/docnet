## 从私有仓库获取镜像
1. 配置密钥
```shell
kubectl create secret docker-registry daocloud \
 --docker-server=daocloud.io \
 --docker-username=136542892 \
 --docker-password=aa5201314 \
 --docker-email=136542892@qq.com
```
2. 获取配置文件
```shell
kubectl get secret regcred --output=yaml
# 输出 json 格式
kubectl get secret regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode
```
3. 使用
```
apiVersion: v1
kind: Pod
metadata:
  name: daocloud-reg
spec:
  containers:
  - name: daocloud-erp-container
    image: daocloud.io/136542892/erp-base-image
  imagePullSecrets:
  - name: daocloud
```
4. 检查
```shell
kubectl get pod daocloud-reg
```
5. 拉取
```shell
kubectl apply -f daocloud-reg-pod.yaml
kubectl delete -f daocloud-reg-pod.yaml
```
- Containerd Issue: https://github.com/containerd/cri/issues/835
- 参考: https://kubernetes.io/zh/docs/tasks/configure-pod-container/pull-image-private-registry/