## Calico 错误信息
1. [WARNING][95] felix/int_dataplane.go 460: Can't enable XDP acceleration. error=kernel is too old (have: 3.10.0-1160 but want at least: 4.16.0)
    1. 命令
    ```shell

    ```
    2. 错误日志:
    ```
    [WARNING][95] felix/int_dataplane.go 460: Can't enable XDP acceleration. error=kernel is too old (have: 3.10.0-1160 but want at least: 4.16.0)
    ```
    3. 解决方案: 
    ```
    ```
2. [WARNING][95] felix/ipip_mgr.go 111: Failed to add IPIP tunnel device error=exit status 1
    1. 命令
    ```shell

    ```
    2. 错误日志:
    ```
    2022-02-10 05:40:28.617 [WARNING][95] felix/ipip_mgr.go 111: Failed to add IPIP tunnel device error=exit status 1
    2022-02-10 05:40:28.617 [WARNING][95] felix/ipip_mgr.go 88: Failed configure IPIP tunnel device, retrying... error=exit status 1
    ```
    3. 解决方案:
    ```
    
    ```



- Calico Issue: https://github.com/projectcalico/calico/issues/5017
