# Route (路由)
### 临时添加路由
1. 为 211 添加网络 192.168.1.0/24
```shell
route add -net 192.168.1.0/24 enp2s0
```
2. 为 105 添加网络 192.168.110.0/24
```shell
route add -net 192.168.110.0/24 enp1s0
```
### 永久添加路由
1. 配置说明
    - dev: 指定设备
    - via: 指定网关
2. 修改文件 /etc/rc.local
   1. 在211服务器配置
       ```shell
       /sbin/route add -net 192.168.1.0/24 gw 192.168.1.1 dev enp2s0
       ```
   2. 在 105 服务器配置
        ```shell
       /sbin/route add -net 192.168.110.0/24 gw 192.168.110.1 dev enp1s0
       ```
3. 在目录/etc/sysconfig/network-scripts 添加文件 route-eth?的网卡名称
    1. 在 211 服务器上添加 route-enp2s0 文件
      ```shell
      # 内容如下(未生效)
      192.168.1.0/24 via 192.168.1.1 dev enp2s0
      ```
    2. 在 105 服务器上添加 route-enp1s0 文件
      ```shell
    
      ```
    3. 重启网卡生效
      ```
      service network restart
      # 或者
      /etc/init.d/network reload
      ```
4. 配置 /etc/sysconfig/static-routes 文件(已验证，k8s cni情况存bug)
    1. 在 211 服务器上配置
    ```shell
    any net any gw 192.168.110.1
    any net 192.168.1.0/24 gw 192.168.1.1
    ```
    2. 在 105 服务器上配置
    ```shell
    any net any gw 192.168.1.1
    any net 192.168.110.0/24 gw 192.168.110.1
    ```
 ### 路由信息
1. 显示路由信息
    ```shell
    route -n
    # 或者
    ip route show
    # 或
    ip route list
    # 查看路由表
    netstat -rn
    ```

参考: https://www.cnblogs.com/struggle-1216/p/12730939.html
参考: https://blog.csdn.net/weixin_33758343/article/details/116808534
命令释义参考: https://blog.csdn.net/weixin_36171533/article/details/83541175
参考: https://blog.csdn.net/weixin_35784370/article/details/116941433