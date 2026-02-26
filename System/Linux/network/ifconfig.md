# ifconfig
## Install ifconfig
1. 首先确认是否有环境变量（ls /sbin/ifconfig）确定没有安装ifconfig
2. 使用yum命令安装（yum install ifconfig）提示：no package ifconfig available：没有可用软件包
3. 使用yum search ifconfig 搜索一下 ifconfig 的相关软件包，显示 matched:ifconfig
4. 重新使用yum命令安装（yum install net-tools.x86_64 -y）
5. 输入ifconfig，显示网络信息。

## ifconfig Setting