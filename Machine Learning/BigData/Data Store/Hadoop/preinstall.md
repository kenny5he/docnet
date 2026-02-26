## 修改hostname
- 永久有效
    ```
        vim /etc/hostname
    ```
- 即时生效
    ```
    hostname new_hostname
    ```
   
## 机器互信机制
1. 生成ssh密钥: ssh-keygen -t rsa
2. 当前用户home目录下.的ssh目录创建文件authorized_keys
3. 拷贝公钥信息至authorized_keys文件

### 问题：
1. authorized_keys公钥文件添加后，无法登陆
    1. 查看系统的安全日志
        ```
            cat /var/log/secure
        ```
    2. 查看系统的安全日志(日志量过多，看最后200行)
        ```
            tail -200 /var/log/secure
        ```
    3. 报错信息:
        ```
            Authentication refused: bad ownership or modes for directory /home/apaye/
        ```
    4. 解决办法:
        ```
        chmod 700 /home/apaye/.ssh
        chmod 600 /home/apaye/.ssh/authorized_keys
        ```
## 修改host
```
    vi /etc/hosts
```
## 关闭linux防火墙
- 永久有效
    ```
    vi /etc/selinux/config
    ```
    设置 SELINUX="" 为 disabled
- 即时生效
    ```
    setenforce 0
    ```
