# Linux NFS
### NFS Server
1. install nfs
```shell
yum -y install nfs-utils rpcbind
```
2. 配置 nfs(/etc/exports)
```
/home/alphafashion/datas/ *(rw,sync,no_root_squash)
```
3. 启动nfs
```shell
# 启动 rpc
systemctl start rpcbind.service
systemctl enable rpcbind
systemctl status rpcbind
# 启动 nfs
systemctl start nfs.service
systemctl enable nfs
systemctl status nfs
```

### NFS Client
1. install nfs
```shell
yum -y install nfs-utils rpcbind
```
2. 启动 nfs
```shell
systemctl start rpcbind.service 
systemctl enable rpcbind.service 
systemctl start nfs.service    
systemctl enable nfs.service
```
3. 检查nfs 共享目录
```shell
showmount -e 192.168.1.105
```
4. 挂载共享目录
    1. 临时挂载NFS目录
    ```shell
    mount -t nfs 192.168.1.105:/home/alphafashion/datas /home/alphafashion/datas
    ```
    2. 永久挂载NFS目录，修改(/etc/rc.d/rc.local)文件，修改文件后需给文件授权 (711)
    ```shell
    mount -t nfs 192.168.1.105:/home/alphafashion/datas/ /home/alphafashion/datas/
    ```
5. 给目录授权
```shell
chmod -R 777 /home/alphafashion/datas/
```
6. 移除挂载
```shell
umount /home/alphafashion/datas
```
- 参考: https://tech.souyunku.com/?p=41612