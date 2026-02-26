## 安装K8s Linux 准备工作
### 网络准备
1. 安装ifconfig
```shell
# 搜索 ifconfig
yum search ifconfig
# 根据搜索结果安装
yum install net-tools.x86_64 -y
```
2. 固定ip
```shell
# 查看网卡
ls /etc/sysconfig/network-scripts/ifcfg-enp*
# 修改配置文件
BOOTPROTO=static
IPADDR=192.168.1.105
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=114.114.114.114
DNS2=8.8.8.8
# 重启网卡
service network restart
```
3. 关闭防火墙
```shell
systemctl disable firewalld --now
```
### hostname
1. 修改hostname(即时生效)
```shell
hostname it105.alphafashion.cn
hostname it211.alphafashion.cn
hostname it10.alphafashion.cn

hostname k8s-node001.microfoolish.com
hostname k8s-node002.microfoolish.com
hostname k8s-node003.microfoolish.com
```
2. 修改hostname文件(永久有效)
```shell
vi /etc/hostname
```
3. 通过hostnamectl 修改
```shell
hostnamectl set-hostname it105.alphafashion.cn
hostnamectl set-hostname it211.alphafashion.cn
hostnamectl set-hostname it10.alphafashion.cn
# 查看hostname
hostnamectl
```
### 关闭swap
1. 查看交换区是否关闭
```shell
cat /proc/swaps
```
2. 关闭交换区
```shell
sudo swapoff -a
```
3. 备份交换区配置
```shell
cp -p /etc/fstab /etc/fstab.bak$(date '+%Y%m%d%H%M%S')
```
4. 注释交换区配置
```shell
sed -i "s/\/dev\/mapper\/centos-swap/\#\/dev\/mapper\/centos-swap/g" /etc/fstab
```
5. 重新挂载
```shell
mount -a
```
6. 查看生效情况
```shell
free -m
cat /proc/swaps
```
7. 创建工作目录
```
mkdir -p /home/alphafashion/datas/tools
mkdir -p /home/alphafashion/datas/apps

mkdir -p /home/alphafashion/workspace/tools
mkdir -p /home/alphafashion/workspace/network
mkdir -p /home/alphafashion/workspace/apps
```