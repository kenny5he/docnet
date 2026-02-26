## Linux 时间设置
1. 查看系统时间
```shell
date
```
2. 安装 ntpdate
```shell
yum install -y ntpdate
```
3. 同步时间
```shell
ntpdate 0.asia.pool.ntp.org
```
4. 同步至硬件
```shell
hwclock --systohc
```
5. 设置时区
```shell
timedatectl set-timezone 'Asia/Shanghai'
```