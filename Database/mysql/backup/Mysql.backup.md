# Mysql Dump
## Mysqldump 备份数据
1. Mysqldump命令语法:
```shell
mysqldump -u root -p --databases 数据库1 数据库2 > xxx.sql
```
2. 操作示例:
    1. 备份全部数据库的数据和结构
        ```shell
        mysqldump -uroot -p123456 -A > /data/mysqlDump/mydb.sql
        ```
    2. 备份全部数据库的结构（加 -d 参数）
        ```shell
        mysqldump -uroot -p123456 -A -d > /data/mysqlDump/mydb.sql
        ```
    3. 备份全部数据库的数据(加 -t 参数)
       ```shell
       mysqldump -uroot -p123456 -A -t > /data/mysqlDump/mydb.sql
       ```
    4. 备份单个数据库的结构和数据
        ```shell
        mysqldump -uroot --host=localhost -p123456 mydb > /data/mysqlDump/mydb.sql
        ```
    5. 备份单个数据库的数据
        ```shell
        mysqldump -uroot -p123456 mydb -t > /data/mysqlDump/mydb.sql
        ```   
    6. 备份多个表的数据和结构（数据，结构的单独备份方法与上同）
        ```shell
        mysqldump -uroot -p123456 mydb t1 t2 > /data/mysqlDump/mydb.sql
        ``` 
    7. 一次备份多个数据库
        ```shell
        mysqldump -uroot -p123456 --databases db1 db2 > /data/mysqlDump/mydb.sql
        ```    
    8. erp-pro案例
        ```shell
        mysqldump -uszalphadb --host=rm-wz997toa3isig9b2jfo.mysql.rds.aliyuncs.com -p'alpha*()rds997' alpha-erp > /var/lib/mysql/erp-pro.sql
        ```
## Mysql 还原数据
1. 在系统命令行中
```shell
mysql -uroot -p'alpha#@!ERP461' alpha_erp < /var/lib/mysql/erp-pro.sql
```
2. 在登录进入mysql系统中,通过source指令找到对应系统中的文件进行还原
```shell
source /data/mysqlDump/mydb.sql
```
# 其它方式
 -> Database -> Backup -> PerconaXtraBackup