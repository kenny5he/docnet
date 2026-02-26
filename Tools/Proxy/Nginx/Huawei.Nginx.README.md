### Demo Of HuaWei
#### HW nginx安装指导(WeLink分享)：
- 服务器信息：dggtsv3c192-ap.mvcloud.huawei.com、nkgtsc7136rhl 
- DNS:webtest-lhs.huawei.com
- 应用上下文根：ces/rls

1. 获取安装包：
```shell
wget http://10.88.60.54/websoft/nginx/nginx_upstream_jvm_route.tar.gz
wget http://10.88.60.54/websoft/nginx/nginx-1.4.4.tar.gz
```
2. 优化系统内核
```shell
echo -e " *\t\t-\tnproc\t\t65535 *\t\t-\tnofile\t\t65535" >> /etc/security/limits.conf
echo -e "fs.file-max = 999999    
         net.ipv4.tcp_tw_reuse = 1
         net.ipv4.tcp_keepalive = 600
         net.ipv4.tcp_fin_timeout = 10
         net.ipv4.tcp_synack_tetries = 3
         net.ipv4.tcp_recycle = 0
         net.ipv4.tcp.ip_local_port_range=1024 6500
         net.ipv4.tcp_max_syn_backlog = 8192
         net.ipv4.tcp_max_tw_buckets = 4000" >> /etc/sysctl.conf
         
# 执行文件查看是否成功 
/sbin/sysctl -e -p /ect/sysctl.conf
```		     
3. 安装依赖包：
```shell
yum install patch.x86_64 -y
yum install gcc -y
yum install -y pcre pcre-devel -y
yum install -y zlib zlib-devel -y
yum install -y openssl openssl-devel -y
```
4. 打补丁
```
cd /tmp/nginx/nginx-1.4.4
patch - p0 < /tmp/nginx/nginx_upstream_jvm_route/jvm_route.patch
```
5. 安装
```shell
# 新版本:
./config --prefix=/opt/webserver/ --with-http_ssl_module --with-http_realip_module --with-http_stub_status_module
  ./configure --prefix=/opt/IBM/nginx --with-http_ssl_module --with-http_realip_module --add-module=/tmp/nginx/nginx_upstream_jvm_route --with-http_stub_status_module
  make
  make install
```

6. 测试
```shell
cd /opt/IBM/nginx/sbin
./nginx -t
```

7. 启动
```shell
./nginx
ps -ef | grep nginx
```

8. 配置nginx.conf
    ```shell
    cd /opt/IBM/nginx/conf
    vim ./nginx.conf
    ```
    - 配置需要使用的域名
    ```
    server {
        listen		80;
        server_name	webtest-lhs.huawei.com
        location /{
            root		html
            index	index.html index.htm
        }
        #设定查看nginx状态
        location /{
            stub_status_on;
            access_log off;
            allow all;
            #deny all;
        }
        #添加反向代理
        location /ces/rls{
            #设置被代理服务器的端口
            proxy_pass http://dggtsv3c192-ap.mwcloud.huawei.com:9080;
        }
    }
    ```
    - 保存并退出后，重启nginx
    ```shell
    ./nginx -s reload
    ```

- 参考: https://www.cnblogs.com/tianhei/p/7726505.html

    
    
    
    
    
    
    
    
    