# Boot Error(引导错误)
1. Started cancel waiting for multipath siblings of sdc.
    1. 配置文件(EFI -> BOOT > grub.cfg)
        - 参考: https://blog.csdn.net/u014692474/article/details/98774668
        ```cfg
        menuentry 'Test this media & install CentOS Linux 8' --class fedora --class gnu-linux --class gnu --class os {
            linuxefi /images/pxeboot/vmlinuz inst.stage2=hd: rd.live.check quiet
            initrdefi /images/pxeboot/initrd.img
        }
       ```
    2. 设置基础软件仓库时出错
        1. 初步认定: 错误原因1: UltraISO 软碟通镜像制作工具问题 (最终验证为 镜像问题，从CentOS 8更改为 CentOS 7后即恢复)
    3. CentOS 网络不通，且无 ifconfig
        1. 初步认定: 网卡设置问题
        2. 原因: 在虚拟机中以最小化方式安装centos7，后无法上网，因为centos7默认网卡未激活。而且在sbin目录中没有ifconfig文件，这是因为centos7已经不使用 ifconfig命令了，已经用ip命令代替； 并且网卡名称也不是eth0了，而是改成eno16777736了。
        3. 解决方案:  
            ```
            1. 使用 ip addr 即查看网卡分配情况。
            2. 激活网卡：在文件 /etc/sysconfig/network-scripts/ifcfg-enp0s3 中
            3. 进入编辑模式，将 ONBOOT=no 改为 ONBOOT=yes，就OK
            ```