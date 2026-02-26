uname -a 查看内核/操作系统/CPU信息 
head -n 1 /etc/issue 查看操作系统版本 
cat /proc/cpuinfo 查看CPU信息 
hostname 查看计算机名 
lspci -tv 列出所有PCI设备 
lsusb -tv 列出所有USB设备 
lsmod 列出加载的内核模块 
env 查看环境变量资源 
free -m 查看内存使用量和交换区使用量 
df -h 查看各分区使用情况
du -h --max-depth=1 /home 查看home目录中文件、文件夹大小
du -sh <目录名> 查看指定目录的大小 
grep MemTotal /proc/meminfo 查看内存总量 
grep MemFree /proc/meminfo 查看空闲内存量 
uptime 查看系统运行时间、用户数、负载 
cat /proc/loadavg 查看系统负载磁盘和分区 
mount | column -t 查看挂接的分区状态 
fdisk -l 查看所有分区 
swapon -s 查看所有交换分区 
hdparm -i /dev/hda 查看磁盘参数(仅适用于IDE设备) 
dmesg | grep IDE 查看启动时IDE设备检测状况网络 
ifconfig 查看所有网络接口的属性 
iptables -L 查看防火墙设置 
route -n 查看路由表 
netstat -lntp 查看所有监听端口 
netstat -antp 查看所有已经建立的连接 
netstat -s 查看网络统计信息进程
top 实时显示进程状态用户 
w 查看活动用户 
id <用户名> 查看指定用户信息 
last 查看用户登录日志 
cut -d: -f1 /etc/passwd 查看系统所有用户 
cut -d: -f1 /etc/group 查看系统所有组 
crontab -l 查看当前用户的计划任务服务 
chkconfig –list 列出所有系统服务 
chkconfig –list | grep on 列出所有启动的系统服务程序 
rpm -qa 查看所有安装的软件包
ps -ef 查看所有进程
    UID       PID       PPID      C     STIME    TTY       TIME         CMD
    zzw      14124     13991      0     00:38    pts/0      00:00:00    grep --color=auto dae

    UID      ：程序被该 UID 所拥有
    PID      ：就是这个程序的 ID
    PPID     ：则是其上级父程序的ID
    C        ：CPU使用的资源百分比
    STIME    ：系统启动时间
    TTY      ：登入者的终端机位置
    TIME     ：使用掉的CPU时间。
    CMD      ：所下达的是什么指令

blog: https://my.oschina.net/u/3136594/blog/3003755(查看linux机器重启信息)