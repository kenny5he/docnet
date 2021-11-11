# Nginx Install
1. Download URL: https://nginx.org/en/download.html
2. Unzip Nginx
```shell
tar -xvf nginx.tar.gz -C /software
```
3. Go Software Dictionary
```shell
cd /software/nginx
```
4. Install Nginx Depend
```shell
# C/C++ Compile
yum install gcc
yum install gcc+
# 正则表达式
yum install -y pcre pcre-devel
# 对HTTP包的内容做gzip的格式压缩
yum install -y zlib zlib-devel
# SSL协议
yum install -y openssl openssl-devel
```
5. Make Install
```shell
./configure
make & make install
```
6. Check Install
```shell
/usr/local/nginx/sbin/nginx -t
```
7. Start Nginx
```shell
# Default Start Nginx
/usr/local/nginx/sbin/nginx

# Load Config Start Nginx
/usr/local/nginx/sbin/nginx -c /temp/nginx.conf

# Load Gobal Config Start Nginx
/usr/local/nginx/sbin/nginx -g "pid /var/nginx/test.pid"

# Load Gobal Config Stop
/usr/local/nginx/sbin/nginx -g "pid /var/nginx/test.pid" -s stop
```
8. Stop Nginx
```shell
# 立即停止服务
/usr/local/nginx/sbin/nginx -s stop
# 关闭监听端口 停止接收新的连接 把当前正在处理的连接全部处理完成
/usr/local/nginx/sbin/nginx -s quit
```
9. 重新加载nginx.conf文件 (Reload Nginx)
```shell
/usr/local/nginx/sbin/nginx -s reload
```