# Cron
cron是一个 Liunx 下 的定时执行工具，可以在无需人工干预的情况下运行作业。
1. 启动服务
```
service crond start  
```
2. 关闭服务 
```
service crond stop
```
3. 重启服务 
```
service crond restart
 ```
4. 重新载入配置
 ```
service crond reload
```
5. 查看服务状态
```
service crond status
```
## Crontab
1. 编写cron脚本文件, 命令格式为
    ```shell
    minute hour day-of-month month-of-year day-of-week commands 合法值 00-59 00-23 01-31 01-12 0-6 (0 is sunday)
    ```
2. crontab命令定期指令编写的定时脚本
    ```shell
    crontab mysqlRollback.cron
    ```
    - 注:  mysqlRollback.cron 为编写的 cron脚本文件
3. cron脚本文件，内容示例
    1. 每隔15分钟
        ```shell
        15,30,45,59 * * * * echo "xgmtest....." >> /tmp/xgmtest.txt
        ```
        - 注: 每隔15分钟，执行打印一次命令,
    2. 每天早上6点
        ```shell
        0 6 * * * echo "Good morning." >> /tmp/test.txt
        ```
    3. 每两个小时
        ````shell
        0 23-7/2，8 * * * echo "Have a good dream" >> /tmp/test.txt
        ````
    4. 每个月的4号和每个礼拜的礼拜一到礼拜三的早上11点
        ````shell
        0 11 4 * 1-3 command line
        ````
    5. 1 月 1 日早上 4 点
        ```shell
        0 4 1 1 * command line SHELL=/bin/bash PATH=/sbin:/bin:/usr/sbin:/usr/bin MAILTO=root
        ```
        - 注: 如果出现错误，或者有数据输出，数据作为邮件发给这个帐号 HOME=
    6. 每小时执行/etc/cron.hourly内的脚本
        ````shell
        01 * * * * root run-parts /etc/cron.hourly
        ````
    7. 每天执行/etc/cron.daily内的脚本
        ````shell
        02 4 * * * root run-parts /etc/cron.daily
        ````
    8. 每星期执行/etc/cron.weekly内的脚本
        ````shell
        22 4 * * 0 root run-parts /etc/cron.weekly
        ````
    9. 每月去执行/etc/cron.monthly内的脚本
        ```shell
        42 4 1 * * root run-parts /etc/cron.monthly
        ```
        - 注: "run-parts" 这个参数了，如果去掉这个参数的话，后面就可以写要运行的某个脚本名，而不是文件夹名











