关机:
	1) halt   立刻关机 
	2) poweroff  立刻关机 
	3) shutdown -h now 立刻关机(root用户使用) 
	4) shutdown -h 10 10分钟后自动关机(用shutdown -c命令取消重启)
	5) init 0
重启:
	1) reboot 
	2) shutdown -r now 立刻重启(root用户使用) 
	3) shutdown -r 10 过10分钟自动重启(root用户使用)  
	4) shutdown -r 20:35 在时间为20:35时候重启(root用户使用)(用shutdown -c命令取消重启)
	5) init 1
linux默认不启动桌面:
	/etc/inittab
		将id:5:initdefault:改为id:3:initdefault:	
linux 目录结构作用：
/bin         常见的用户指令
/boot        内核和启动文件
/dev         设备文件
/etc         系统和服务的配置文件
/home        系统默认普通用户家目录
/lib         系统函数库目录
/lost+found  ext3文件系统所需目录，用于磁盘检查
/mnt         挂载点/挂载目录(系统加载文件时常用的挂载点)
/opt         第三方软件安装目录
/proc        虚拟文件目录
/root        root用户的家目录
/sbin        存放系统管理命令
/tmp         临时文件存放目录
/usr         存放与用户直接相关的文件和目录
/media       系统用来挂载光驱等临时文件系统的挂载点

linux文件系统
  支持 ext2/ext3/ext4/zfs/iso9660/vfat/msdos/smbfs/nfs
  创建文件系统(fdisk)
    df -hT 查看磁盘使用情况
    fdisk -l 列出磁盘信息
    fdisk /dev/sdv 然后输入字母n(n代表new 新建分区)
    extended (扩展分区) / primary partition (主分区)
    partition number 1 代表第一个分区
    First cylinder (磁盘开始柱面)
    Last cylinder or +sizeM or +sizeK (最后一个柱面位置)
    Command (m for help):w(将刚刚创建的分区写入分区表)
    fdisk -l 列出磁盘信息
    mkfs -t ext3 /dev/sdb1  也可写成  mkfs.ext3 /dev/sdb1
    (如果线索xxx is apparently in use by system will ont make a filesystem here! 则dmsteup status查看状态，dmsteup remove_all移除所有)
  挂载磁盘
    mkdir disk
    mount /dev/sdb1 disk(将disk文件夹的内容全部挂载到文件系统 /dev/sdb1中)
  自动挂载(/etc/fstab)
    echo "/dev/sdb1 /root/disk ext3 defaults 0 0" >>/etc/fstab
  磁盘检验(fsck/badblocks)
    fsck 需要在未挂载状态,否则会造成文件系统损坏
    badblocks 主要检测磁盘物理坏道
  
  linux逻辑卷
    关系： 
        物理卷(Physical Volume,PV) == 物理磁盘分区 
        逻辑卷(Logic Volume,LV) == 物理分区中画出来的逻辑磁盘
    操作：
        创建物理卷(pvcreate)
          pvcreate /dev/sdb1
        显示PV使用状态(pvdisplay)
        创建物理卷组(vgcreate)  
          vgcreate /dev/sdb1 /dev/sdb2 ...等多个物理卷
        显示物理卷组(vgdisplay)
        扩容物理卷组(vgextend)
          vgextend vg_name device1....devicen(vg_name:需要增加的vg名，deviece 指设备)
        创建逻辑卷(lvcreate)
         lvcreate -L SIZE -n LV_NAME VG_NAME (VG_NAME 代表从某个物理卷中划分逻辑卷)
        显示逻辑卷(lvdisplay) 
    当该文件系统成功挂载后将能够使用逻辑卷，访问路径 /dev/卷组名/逻辑卷名
    
查看linux系统相关信息
    ```shell
        # 查看系统信息/系统版本
        cat /proc/redhat
        # 查看OS信息
        cat /etc/os-release
        # 查看cpu配置:
        cat /proc/cpuinfo
        # 查看内存情况: 
        
    ```
  查看内存/CPU/进程情况
  top
     列含义：
        PID     进程ID
        USER    进程所有者
        PR      进程优先级
        NI      nice值，正代表高优先级，负代表低优先级
        VIRT    使用虚拟内存量
        RES     进程使用未被换出的物理内存大小
        SHR     共享内存大小
        %CUP    上次更新到现在的CPU时间占用比
        %MEM    进程使用物理内存百分比
        TIME+   进程使用CPU时间总计
        COMMAND 进程名称(命令名/命令行)
  查看CPU信息
  cat /proc/cupinfo
  查看内存信息
  cat /proc/meminfo
  查看相关进程
  ps -ef|grep java
     参数
         -A      列出所有进程
         -a      列出不和本终端有关的所有进程
         -w      显示加宽
         -u      显示有效使用者相关进程
         -e      与指定"A"参数相同
         e       命令之后显示环境 
         -f      全部列出
         -N      忽略选择
         -p      pid进程使用时间
         -l      长格式
         -j      作业格式()
         -H      显示进程层次(树状结构)
      输出
         USER    进程拥有者
         PID     pid
         %CUP    CPUs使用率
         %MEM    内存使用率
         VSZ     虚拟内存大小
         RSS     占用内存大小
         TTY     运行终端的号码
         STAT    进程状态(D:不可中断 R:运行中 S:休眠 T:暂停 Z:僵尸进程 W：没有足够内存分配 <高优先级 N：低优先级)
  杀掉进程
  kill pid
  查询进程打开的文件
  lsof [option] filename
     lsof -c String 显示COMMAND列包含指定字符的进程所有打开文件
     lsof -u username 显示属于user进程打开的文件
     lsof -g gid 显示归属与gid的进程情况
     lsof +d /DIR/ 显示目录下被进程打开的文件
     lsof +D /DIR/ 搜索目录下所有目录被打开的所有文件
     lsof -d FD  显示指定文件描述符的进程
     lsof -n  不将IP转换为hostname,默认是不加-n参数
     losf -i 显示相符合条件的进程情况 
     例:
        检查端口是否被占用: lsof -i:8080
  进程优先级
     nice -n -10 ./job.sh(以高优先级运行程序，数值越小越优先)
     renice -10 -p pid(修改已运行的程序优先级)
  查看所有端口占用情况
  netstat   -anp
  查看8080端口占用情况
  netstat -anp | grep 8080
  查看是否已安装文件
  yum list | grep xxx
  查看系统时间
  date
  列出目录内容
  ls 
  显示文件内容
  cat xxx
  命令释义(reboot的释义)
  man -f reboot
  说明文档(ls 的说明)
  info ls
  
  系统运行级别0-6 共7个级别  
  运行级别 0：关机
  运行级别 1：单用户模式，系统出现故障，可用该模式进入系统维护
  运行级别 2：多用户模式，该模式没有网络连接
  运行级别 3：完全多用户模式，最常见的运行级
  运行级别 4：保留未使用
  运行级别 5：窗口模式，该模式支持多用户，支持网络
  运行级别 6：重启
  任务前后台切换(bg/fg/jobs)
    Ctrl+z (暂停前台任务)
    jobs   (查看暂停的任务)
    bg 任务编号(将任务放置到后台继续执行)
    fg 任务号(将任务号放置到前台执行)
  
  用户/组
    1)Linux用户
      类别：
        普通用户        UID>500          权限：其home目录/系统临时目录/经过授权目录/属于该用户的文件
        根用户          UID=0            权限：对系统完全控制(root)
        系统用户        UID=1~499        不一定指真实使用者(apache/mysql)
      系统密码
        /etc/passwd 和 /etc/shadow
      创建用户/修改密码/修改用户/删除用户
        创建用户：useradd john
        修改密码：passwd john
        修改用户：usermod -d /home/john_new -m alice  (修改john的home目录为/home/john_new)
        删除用户：userdel john
        新增用户同时增加群组： useradd -g groupname user
        将用户添加至群组(已有用户/已有群组)：usermod -G groupname username (会把用户从其它群组去除) / gpasswd -a user group
        将用户从群组删除：gpasswd wheel -d user
      检查用户信息(users/who/w)
            users  查看当前系统存在哪些用户
            who    当前系统登录用户的信息
            finger 调查用户(例：finger oracle)
      切换用户(su/sudo) 
    2)Linux 群组
      新增/删除群组
        新增群组：groupadd oracle_group
        删除群组：groupdel oracle_group
    blog: https://www.cnblogs.com/jackyyou/p/5498083.html
  定时任务：
     单一时刻执行：at 
        例：三十分钟后执行 关闭系统的任务(Ctrl D 输入结束)
          # at now + 30 minutes
          at> /sbin/shutdown -h now
        查看at命令调度任务列表：atq
    周期执行任务：cron (定时任务配置文件：/etc/corntab)
        1)确定crond进程是否在运行，如果没有则启动该进程
          service crond status   service crond start      
        2)设置执行任务(crontab)
           格式：* * * * * command
           例: 每分钟 http进程重启一次
             */1 * * * * * service httpd restart
        3)crontab常用其它命令参数
         crontab -l 查看设置任务
         crontab -r 删除所用任务
         crontab -e 编辑定义任务
  硬链接/软链接
     硬链接==实际链接 (不允许给目录创建硬链接，不同分区不能够建立硬链接)
     软链接 删除后不会删除源文件
     创建硬链接
         touch hard01 (创建文件)
         ln hard01 hard01_link(创建硬链接 hard01_link)
     创建软链接
         mkdir soft (创建文件夹)
         touch file (创建文件)
         ln -ds soft /soft(给文件夹创建软链接)
         ls -s file /file(给文件创建软链接)
  文件夹操作:
     查看文件目录大小: du
        参数:
            -h：以人类可读的方式显示
        　　-a：显示目录占用的磁盘空间大小，还要显示其下目录和文件占用磁盘空间的大小
        　　-s：显示目录占用的磁盘空间大小，不要显示其下子目录和文件占用的磁盘空间大小
        　　-c：显示几个目录或文件占用的磁盘空间大小，还要统计它们的总和
        　　--apparent-size：显示目录或文件自身的大小
        　　-l ：统计硬链接占用磁盘空间的大小
        　　-L：统计符号链接所指向的文件占用的磁盘空间大小
  文件操作：
  	 远程拷贝文件: scp (blog: https://www.cnblogs.com/likui360/p/6011769.html)
  	 	scp -r local_folder remote_username@remote_ip:remote_folder  
     创建文件: touch
     删除文件：rm
     移动文件：mv
     查看文件：cat
     查看文件头：head
     查看文件尾：tail
     编辑文件: vi or vim file
     	i: 进入add编辑模式 esc: 退出编辑模式
     	Ctrl + D 下一页 Ctrl + B 上一页 g 首行  G 尾行 
     	:set ignorecase 设置不区分大小写  /xxxx 查找(n 下一处匹配, N 反方向查找) 
     	:q 退出 !q强制退出 wq保存并退出
     文件格式转化：dos2unix
     查看文件或目录的权限：ls -al
         第一列
            第一个字符的值        含义
                d                目录
                -                普通文件
                l                链接文件
                b                块文件
                c                字符文件
                s                socket文件
                p                管道文件
            2～4代表该文件所有者权限 rwx
            5～7代表所有组的权限 rwx
            8~10代表其它用户拥有的权限 rwx   
         第二列代表连接数
         第三列代表所有人
         第四列代表所有组
         第五列代表文件大小
         第六列代表创建时间或最后修改时间
     文件属性(lsattr chattr)(操作(+-=)(共有13个属性(aAcCdDeijsStTu))
         chattr +a file (只能在尾部新增数据而不能被删除)
         chattr +i file (文件将无法写入/删除/改名)
     文件授权
       chmod u/g/o +/-/= r/w/x somefile/somedir (u:用户 g:同组所有 o:其它 a:所有用户 +:增加 -:删除 =:赋予  r:读 w:写 x:执行)(不能单用户授权)
          例：chmod u+rwx /usr/local/nexus
     改变文件拥有者
       chown u somefile/somedir (改为某个用户) / chown :g somfile/somedir (改为某个群组)
          例：chown john a.txt       /  chown :john somefile
            只改变文件或目录的所有者
            chown -R owner: somefile
            只改变文件或目录的群组
            chown -R :group somefile
          递归设置 文件子目录/子目录下所有文件  chown -R john somedir   
     改变文件拥有组
       chgrp g somefile/somedir   
     umask(遮罩)
        创建    root    普通用户
       文件夹    755       775
        文件     644       664
       UID大于99 umask为002 否则为022(root 用户是022，普通用户是002)
       777表示 rwxrwxrwx，如果遮罩值为022，则表示----w--w-,第五位和第八位遮罩掉，权限变为:rwxr-xr-x，用数字表示：755。如果遮罩值为002，用字符表示-------w-，那么第八位遮罩掉，权限变为:rwxrwxr-x，用字符表示为775。
       666表示 rw-rw-rw-，如果遮罩值为022，则表示----w--w-，第五位和第八为遮罩掉，权限变为:rw-r--r--，用数字表示：644。如果遮罩值位002，用字符表示-------w-，那么第八位遮罩掉，权限变为:rw-rw-r--，用字符表示为664。
     setfacl/getfacl(精确设置文件权限)
        用法: setfacl [-bkndRLP] { -m|-M|-x|-X ... } file ...
            -m,       --modify-acl 更改文件的访问控制列表
            -M,       --modify-file=file 从文件读取访问控制列表条目更改
            -x,       --remove=acl 根据文件中访问控制列表移除条目
            -X,       --remove-file=file 从文件读取访问控制列表条目并删除
            -b,       --remove-all 删除所有扩展访问控制列表条目
            -k,       --remove-default 移除默认访问控制列表
                      --set=acl 设定替换当前的文件访问控制列表
                      --set-file=file 从文件中读取访问控制列表条目设定
                      --mask 重新计算有效权限掩码
            -n,       --no-mask 不重新计算有效权限掩码
            -d,       --default 应用到默认访问控制列表的操作
            -R,       --recursive 递归操作子目录
            -L,       --logical 依照系统逻辑，跟随符号链接
            -P,       --physical 依照自然逻辑，不跟随符号链接
                      --restore=file 恢复访问控制列表，和“getfacl -R”作用相反
                      --test 测试模式，并不真正修改访问控制列表属性
            -v,       --version           显示版本并退出
            -h,       --help              显示本帮助信息
        例: 给用户zhangy设置test文件的读写权限
            setfacl -m u:zhangy:rw- test
            获取文件test的权限信息
            getfacl test

     查找文件(find/locate)/查找执行文件(witch/whereis)
       find(实时查询)
           find / -name file(按照文件名称查找)
           find / -perm (按照文件权限查找)
           find / -user username (按照用户名查找)
           find / -mtime -n/+n (查找n天内/查找n天前更改过的文件)
           find / -atime -n/+n (查找n天内/查找n天前访问过的文件)
           find / -ctime -n/+n (查找n天内/查找n天前创建过的文件)
           find / -newer file (查找更改时间比filename新的文件)
           find / -type b/d/c/p/l/f/s(查找 块/目录/字符/管道/链接/普通/套接字文件)
           find / -size 根据文件大小查找
           find / depth n 最大的查找目录深度
       locate(延时查询，定期更新扫描更新库)(updatedb 手动更新命令)
          locate file
       witch 从系统的PATH变量目录查询可执行文件的绝对路径
       whereis 不但能查询到二进制文件，也能查询到相关man文件  
     压缩/解压
         zip demo   blog url: http://www.jb51.net/LINUXjishu/105916.html
           1、压缩mydata目录
           zip -r mydata.zip mydata 
           2、把/home目录下面的mydata.zip解压到mydatabak目录里面
           unzip mydata.zip -d mydatabak
           3、把/home目录下面的abc文件夹和123.txt压缩成为abc123.zip
           zip -r abc123.zip abc 123.txt
         gzip/gunzip
           gzip file (压缩文件)
           gunzip file.gz (解压文件)
         tar(z:使用gzip压缩 c:创建压缩文件 v:显示当前压缩文件 f:使用文件名 )  
           demo :
             tar -zcvf boot.gz /boot(压缩boot)
             tar -zxvf boot.gz -C /tmp/(解压boot至tmp目录)
         bzip2(z: 压缩 d:解压)
           demo:
             bzip2 -z /boot (压缩)
             bzip2 -d boot.bz2(解压)
  字符处理
      grep搜索文本
         i   不区分大小写
         c   统计包含匹配行数
         n   输出行号
         v   反向匹配
         例：grep 'name' toAndJerry.txt
      sort排序
         n   采取数字排序
         t   指定分割符
         k   指定第几列
         r   反向排序
         例：cat toAndJerry | sort -r
      uniq 删除重复文本
         例：cat toAndJerry.txt sort | uniq
      cut 截取文本
         cut -f列 -d'分割符'
         例：cut -f1,6 -d':'
      使用tr文本转换
         例：cat /etc/passwd | tr '[a-z]' '[A-Z]'
      使用paste文本合并
         例：paste a.txt b.txt
      使用split分割大文件
         split -l 500 big_file.txt small_file_ (指定每500行分割为一个文件)
      sed(非交互式的流编辑器)(并不会改变文件本身)
        sed [options] 'command' file
        options是sed接受的参数
        command是sed的命令集
        sed常用命令
            a    在匹配行后面加入文本
            c    字符转换
            d    删除行
            D    删除第一行
            i    在匹配行前面加入文本
            h    复制模板块的内容到存储空间
            H    追加模板块的内容到存储空间
            g    将存储空间的内容复制到模式空间
            G    将存储空间的内容追加到模式空间
            n    读取下一个输入行，用下一个命令处理新的行
            N    追加下一个输入行到模板块并在二者间插入新行
            p    打印匹配的行
            P    打印匹配的第一行
            q    退出sed
            r    从外部文件中读取文本
            w    追加写文件
            !    匹配的逆
            s/old/new 用new替换正则表达式 old
            =    打印当前行好
        sed常用参数
            -e   多条件编辑
            -h   帮助信息
            -n   不输出不匹配的行
            -f   指定sed脚本
            -V   版本信息
            -i   直接修改原文件
        demo案例
            删除
                sed '1d' Sed.txt(删除第一行)
                sed '1,3d' Sed.txt(删除1至3行) sed '1,$d' Sed.txt(删除1至最后一行)
                sed '/Empty/d' Sed.txt(删除所有包含Empty的行)
                sed '/^$/d' Sed.txt(删除所有空白行)
            查找替换
                sed 's/line/LINE' Sed.txt(使用LINE替换line)(只替换第一次匹配内容)
                sed 's/line/LINE/2' Sed.txt(使用LINE替换line)(替换两次)
                sed 's/line/LINE/g' Sed.txt(使用LINE替换line)(完成所有替换)
                sed 's/7000/7001/g' redis.conf > redis7001.conf(将redis.conf中的使用7001替换7000然后输出为新文件，redis.conf无更改)
            字符转换
                sed 'y/12345/ABCDE' Sed.txt(将1替换成A，将2替换成B...)
            插入文本               
                sed '2 i Insert' Sed.txt(使用i在第二行前插入文本Insert)
                sed '2 a Insert' Sed.txt(使用i在第二行后插入文本Insert)
            读入文本
                sed '/^$/r /etc/passwd' Sed.txt(将/etc/passwd中的内容读取放到Sed.txt空行后)
            打印
                sed -n '1p' Sed.txt(打印第一行)
            写文件
                sed -n '1,2 w output' Sed.txt(输出1至2行到output文件)    
      awk(文本打印)
        案例
            awk '{print $1,$4}' Awd.txt(打印第一列和第四列)
            awk '{print $0}' Awd.txt(打印全部内容)
            awk -F. '{print $1,$2}' Awd.txt(指定.作为分割符)(适用于property=value)
            awk '{print NF}' Awd.txt (使用默认分割符，获取行的列数)
            awk '{print $NF}' Awd.txt(打印出最后一行)
            awk '{print $(NF-1)}' Awd.txt(打印倒数第二行)
            cat Awd.txt | awk '{print substr($1,6)}' 阶取第一个列中第6个字符到最后一个字符的内容
网络管理      
  0.网络配置文件
  		
  1.网络接口配置(ifconfig)
      定义：
        eth 代表以太网，0代表第一块网卡，HWaddr代表硬件地址
        inet addr代表IP地址，Mask代表掩码，Broadcast代表广播地址，UP 激活状态，
      命令：
        ifconfig 输出当前系统处于活动的网络状态
        ifconifg eth0 192.168.159.130 netmask 255.255.255.0(指定eth0的IP地址)
        ifconfig ech0 down (断开网卡0)
        ifconfig ech0 up (启用网卡0)
        网络配置文件地址(RedHat内核)：/etc/sysconfig/network-scripts
        cat ifcfg-eth0
          DEVICE=eth0 (设备0)
          BOOTPROTO=dhcp (IP获取方式，dhcp/static)
          ONBOOT=yes (是否启用)
        service network restart(重启网络服务)
        ip addr 查看当前网络ip信息
    配置网络
		配置文件:vim /ect/sysconfig/network-scripts/ifcfg-eth0    
		重启network: /etc/sysconfig/network restart
		配置hostname: vim /etc/sysconfig/network   
  2.路由与网关
      添加默认网关：route add default gw 192.168.159.2
      删除默认网关：route del default gw 192.168.159.2
      route -n 查看系统当前路由表
      配置文件：/etc/sysconfig/network
  3.DNS配置(/etc/hosts)
      DNS的作用：加快域名解析，方便小型局域网用户使用内部设备  
      设置主机为DNS客户端的配置文件/etc/resolv.conf  
      nameserver 196.168.0.1 192.168.154.4 196.168.9.254(先查询第一个，当一个不可用时查询第二个，限定3个)
      search www.google.com(全局限定域名)
      domain  www.google.com(与search类似，但限定一个域名)
  4.网络测试工具
     ping 域名(查询连通性)
     host 域名(查询DNS信息)
     traceroute(监测数据包)
  5.设置防火墙：
      1)firewall-cmd（blogs：http://blog.csdn.net/steveguoshao/article/details/45999645 5星理论+脚本命令）
      	#获取firewall的状态
        systemctl status firewalld 或者 firewall-cmd --state && echo "Running" || echo "Not running"
      	#获取支持的区域列表
		firewall-cmd --get-zones
		#获取所有支持的服务
		firewall-cmd --get-services
        # 按端口：打开TCP的8080端口  (firewall-cmd)
        firewall-cmd --zone=public --add-port=8080/tcp --permanent
        # 按服务：打开HTTP的默认端口
        firewall-cmd --zone=public --add-service=http --permanent
        # 重新加载防火墙
        firewall-cmd --reload
      2)iptables(静态防火墙规则配置文件是 /etc/sysconfig/iptables 以及 /etc/sysconfig/ip6tables)
      	#源码安装
      	./configure -prifix=/some/path. && make & make install
      	#yum安装
      	yum install iptables-services
      	#屏蔽firewall服务
		systemctl mask firewalld.service
		#启用iptables服务
		systemctl enable iptables.service
		#启用ip6tables服务
		systemctl enable ip6tables.service
		#停止firewall服务
		systemctl stop firewalld.service
		#启动iptables服务
		systemctl start iptables.service
		#启动ip6tables服务
		systemctl start ip6tables.service
		#查看iptables的状态
		service iptables status
		#永久关闭iptables
		chkconfig iptables off
      	#清空所有规则
      	iptables -F
      	#删除所有自定义链
      	iptables -X
      	#输入(INPUT)的数据包默认的策略是丢弃的
      	iptables -P INPUT DROP
      	#输出(OUTPUT)的数据包默认的策略是丢弃的
      	iptables -P OUTPUT DROP
      	#允许icmp包进入
      	iptables -A INPUT -p icmp --icmp-type any ACCEPT
      	#允许icmp包出去
      	iptables -A OUTPUT -p icmp --icmp any ACCEPT
      	#允许本地数据包入
      	iptables -A INPUT -s localhost -d localhost -j ACCEPT 
      	#允许本地数据包出
      	iptables -A OUTPUT -s localhost -d localhost -j ACCEPT
      	#允许已建立和相关的数据包进入
      	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
      	#允许已建立和相关的数据包出去
      	iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
        #开放 8080 端口  
        iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
        # 特定ip ssh链接服务器
        iptables -A INPUT -p tcp --dport 22 -s 192.168.1.10 -j ACCEPT
        # 连接其它服务器
        iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
        #保存配置
        /etc/rc.d/init.d/iptables save
  6.linux设置自启动方式(软链接方式/)
      1)软链接方式
        /etc/inittab(Linux中有7种运行级别)每个运行级别对应/etc/rc.d/rc[0~6].d目录
        K开头的脚本文件代表运行级别加载时需要关闭的，S开头的代表需要执行
        例：ln -s /etc/init.d/sshd /etc/rc.d/rc3.d/S100ssh
      2)chkconfig
        自启动某些服务，只需使用chkconfig 服务名 on即可，若想关闭，将on改为off 
        (--level选项启动自定义级别  --list选项可查看指定服务的启动状态) 
        例：chkconfig sshd on
      3)ntsysv 伪图形
         启动ntsysv有两种方式，一是直接在命令行中输入ntsysv，二是使用setup命令，然后选择系统服务
      4)手动启动某服务
         /etc/init.d 服务名 start
         service 服务名 start
         
软件安装(源码安装(./configure,make,make install) rpm安装  yum安装)
  源码安装
     ./configure(C编译)
       路径相关参数                     意义                  
     --prefix=PATH               安装部署后的目录        
     --sbin-path=PATH            可执行文件路径             
     --conf-path=PATH            配置文件路径                
     
       编译相关参数                     意义
     --with-cc=PATH         C编译路径
     --with-cpp=PATH        C预编译路径
     --with-cc-opt=OPTIONS  编译期间指定一些编译选项，如果指定宏或者使用-I加入某些包含目录
     --with-opt=OPTIONS     用于加入链接时的参数
     --with-cpu-opt=CPU     指定CPU处理架构，取值(pentium/pentiumpro/pentium3/pentium4/athlon/opteron/sparc32/sparc64/ppc64)
     
  
  rpm安装/卸载/查询
     参数
        -i             安装软件
        -v             打印详细信息
        -h             使用#号打印安装进度
        -e             删除软件
        -U             升级软件
        --replacepkge  如果已安装，则强行安装
        --test         安装测试
        --nodeps       忽略软件包依赖关系强行安装
        --force        忽略软件包及文件的冲突
        -a             查询所有安装软件
        -p             查询某个安装软件
        -l             列出某个软件包含的所有文件
        -f             查询某个文件的所属包
     Demo
        rpm -ivh gcc.rpm(安装gcc)
        rpm -Uvh gcc.rpm(升级gcc)
        rpm -e gcc --nodeps (卸载gcc)
        rpm --import RPM-GPG-KEY(导入签名)
        rpm -p gcc(查看gcc是否已安装)
        rpm -qpR gcc.rpm(查看gcc包的依赖关系)
        ldd sqlplus (查看sqlplus软件依赖情况)
  yum安装/查询
      yum install PACKAGE 安装包
      yum update PACKAGE 更新包
      yum remove PACKAGE 删除包
      yum check-update 检查所有需要更新的包
      yum list 查找源所有可用包
      yum clean 清除缓存
      源文件地址：/etc/yum.repos.d(CentOS 可能需要修改源配置为centos地址)
      自建源：
        [base] (命名base源)
        name=CentOS-7 - Base(源名字)
        baseurl=http://centos.ustc.edu.cn/centos/5/os/$basearch/(源地址，$basearch是变量，支持http/file/ftp)
        gpgchek=1(开启验证)
        gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7(定义gpgkey地址)
  linux内建系统命令
      type cd(确定内建命令)
      . ./HelloWorld.sh(执行Shell命令)
      alias (创建别名)(alias myShutdown='shutdown -h now')(ll='ls -l' 系统自带简写命令)
      unalias(删除别名)
      
linux软件安装准则：
    /software                  软件安装包位置
    /opt/xxxx                  软件安装位置 (jdk除外)
    /usr/local/java/jdk1.x     jdk安装位置
    
软件版本切换: 
    usage: alternatives --install <link> <name> <path> <priority>
	  [--initscript <service>]
	  [--slave <link> <name> <path>]*
	  alternatives --remove <name> <path>
	  alternatives --auto <name>
	  alternatives --config <name>
	  alternatives --display <name>
	  alternatives --set <name> <path>
	common options: --verbose --test --help --usage --version
	  --altdir <directory> --admindir <directory>
	说明：
	alternatives --install <link> <name> <path> <priority>
		install表示安装
		link是符号链接
		name则是标识符
		path是执行文件的路径
		priority则表示优先级    
	扩展:(java版本管理 https://www.cnblogs.com/yx1989/archive/2017/07/05/7118433.html)   
		git clone https://github.com/gcuisinier/jenv.git ~/.jenv
		echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bashrc
		echo 'eval "$(jenv init -)"' >> ~/.bashrc
		source ~/.bashrc
		#添加JDK
		jenv add /usr/local/src/jvm/jdk-1.6.0.45
		#设置全局(默认)JDK
		jenv global 1.7
		#设置当前目录jdk
		jenv local 1.6
		#取消当前目录设置
		jenv local --unset
		
环境变量:
	/etc/profile : 在登录时,操作系统定制用户环境时使用的第一个文件 ,此文件为系统的每个用户设置环境信息,当用户第一次登录时,该文件被执行。 
	/etc/environment : 在登录时操作系统使用的第二个文件, 系统在读取你自己的profile前,设置环境文件的环境变量。 	
	~/.profile :  在登录时用到的第三个文件 是.profile文件,每个用户都可使用该文件输入专用于自己使用的shell信息,当用户登录时,该文件仅仅执行一次!默认情况下,他设置一些环境变量,执行用户的.bashrc文件。
	/etc/bashrc : 为每一个运行bash shell的用户执行此文件.当bash shell被打开时,该文件被读取. 
	~/.bashrc : 该文件包含专用于你的bash shell的bash信息,当登录时以及每次打开新的shell时,该该文件被读取。 
    
 
    
    
Kenny.54
	
获取当前公网ip：curl myip.ipip.net
mac配置虚拟机ip: https://blog.csdn.net/sanwenyublog/article/details/53054466