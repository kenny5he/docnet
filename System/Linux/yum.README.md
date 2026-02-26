## yum 安装
1. 安装yum管理 工具
```
yum install -y yum-utils
```
2. 通过管理工具添加 yum 源
```shell
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```
3. 添加 yum 源
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
4. 添加 163 网易源
```shell
yum-config-manager --add-repo http://mirrors.163.com/.help/CentOS7-Base-163.repo
```
5. 替换 CentOS7-Base.repo 为清华源
```shell
sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' \
     -e 's|^#baseurl=http://mirror.centos.org|baseurl=https://mirrors.tuna.tsinghua.edu.cn|g' \
     -i.bak \
     /etc/yum.repos.d/CentOS7-Base-163.repo
```