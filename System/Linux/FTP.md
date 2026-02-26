# Ftp Server
1. 安装 FTP
```
yum install -y vsftpd
```
2. 配置 ftp 文件 (/etc/vsftpd/vsftpd.conf)
```
# 允许匿名用户访问为了安全选择关闭
anonymous_enable=NO
# 允许本地用户登录
local_enable=YES
# 是否允许写入
write_enable=YES
# 本地用户上传文件的umask
local_umask=022
# 为YES则进入目录时显示此目录下由message_file选项指定的文本文件(,默认为.message)的内容
dirmessage_enable=YES
# 开启日志
xferlog_enable=YES
# 标准格式
xferlog_std_format=YES
connect_from_port_20=YES
# ftp日志目录
xferlog_file=/var/log/xferlog
# 设置客户端连接时间
idle_session_timeout=6000
# 设置数据连接时间 针对上传，下载
data_connection_timeout=1200
chroot_list_enable=YES
# 设置为YES则下面的控制有效
chroot_list_file=/etc/vsftpd/chroot_list
# 若为NO,则记录在chroot_list_file所指定的文件(默认是/etc/vsftpd.chroot_list)中的用户将被chroot在登录后所在目录中,无法离开.如果为YES,则所记录的用户将不被chroot.这里YES.
chroot_list_enable=YES
chroot_local_user=YES
# 若设置为YES则记录在userlist_file选项指定文件(默认是/etc/vsftpd.user_list)中的用户将无法login,并且将检察下面的userlist_deny选项
userlist_deny=NO
# 若为NO,则仅接受记录在userlist_file选项指定文件(默认是/etc/vsftpd.user_list)中的用户的login请求.若为YES则不接受这些用户的请求.
userlist_enable=YES
# 白名单
userlist_file=/etc/vsftpd/user_list
chroot_list_enable=YES
# 根目录
local_root=/var/ftp/pub
listen=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
```
3. 自启动 ftp server 服务
```shell
systemctl enable vsftpd.service
```