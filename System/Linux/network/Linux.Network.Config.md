# Linux Network

### 网络配置场景
1. 固定IP
    1. ifconfig
        ```
        1. (指定eth0的IP地址)
        ifconfig eth0 192.168.1.105 netmask 255.255.255.0
        ```
    2. 修改网卡配置文件
        ```
        1. 查看网卡 
        ls /etc/sysconfig/network-scripts/ifcfg-enp*
        
        2. 修改对应网卡配置文件
        # stattic: 静态, dhcp:
        BOOTPROTO=static
        IPADDR=192.168.1.105
        NETMASK=255.255.255.0
        GATEWAY=192.168.1.1
        DNS1=8.8.8.8
        DNS2=114.114.114.114
       
        # IPV4
        IPV4_FAILURE_FATAL=no
        #IPV6
        IPV6INIT=yes
        IPV6_AUTOCONF=yes
        IPV6_DEFROUTE=yes
        IPV6_FAILURE_FATAL=no
        IPV6_ADDR_GEN_MODE=stable-privacy
        3. 重启网卡
        service network restart
        ```
