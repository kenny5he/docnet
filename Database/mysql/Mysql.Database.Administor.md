## Mysql DBA 必备知识
### Mysql 高级命令
1. 查询空闲连接信息（注意: 客户端如果太长时间没动静，连接器就会自动将它断开。这个时间是由参数 wait_timeout 控制的，默认值是 8 小时）
```
/* Commond 状态为 Sleep */
show processlist
```

2. 查询配置值
```
show variables
  or
show variables like 'transaction_isolation'
```
3.  设置配置值
```sql

```
4. 查看执行计划
```sql
explain select user_id,user_name,user_account from tbl_user where user_id = 4212143; 
```

### Mysql information_schema
   
| 表/视图 | 说明 |
| --- | --- |
|information_schema.innodb_trx |当前运行的所有事务|
|information_schema.innodb_locks |当前出现的锁|
|information_schema.innodb_lock_waits |锁等待的对应关系|

1. 查询时间较长的事务
```sql
select * from information_schema.innodb_trx where TIME_TO_SEC(timediff(now(),trx_started))>60
```
2. 未提交事务导致后来进程死锁等待的进程
```sql
select trx_mysql_thread_id 
    from information_schema.innodb_trx it ,
        information_schema.INNODB_LOCK_WAITS ilw 
where ilw.blocking_trx_id = it.trx_id;

 /* 杀掉线程 */
 kill #trx_mysql_thread_id
```
