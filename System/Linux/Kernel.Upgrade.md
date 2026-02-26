# Linux 内核升级 

## 升级操作系统内核
1. 导入 Public Key
```shell
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
```
2. Install Repo
```shell
yum install https://www.elrepo.org/elrepo-release-9.el9.elrepo.noarch.rpm
```
3. 安装kernel-ml版本 (ml 长期稳定版本，lt 长期维护版本)
```shell
yum --enablerepo="elrepo-kernel" install kernel-ml.x86_64 -y
```
4. 检查版本
```shell
uname -r
```