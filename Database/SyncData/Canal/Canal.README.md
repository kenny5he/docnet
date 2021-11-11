#Canal

## 注意事项
1. Canal只支持 Mysql Binlog的ROW 模式
```conf
# 开启 binlog
log-bin=mysql-bin
# 选择 ROW 模式
binlog-format=ROW
# 配置 MySQL replaction 需要定义，不要和 canal 的 slaveId 重复
server_id=1 
```
2. 重启数据库查看配置生效情况
```
/** 检查bin log 模式 **/
show variables like 'binlog_format';
/** 检查是否开启bin log **/
show variables like 'log_bin';
/** 检查Master状态 **/
show master status;
```
3. 开启同步账号，授予权限
```
/** 创建账号 **/
CREATE USER canal IDENTIFIED BY 'EWDRXbsG%pmce!EC';
/** 给账号授权 **/
GRANT SELECT, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'canal'@'%%';
FLUSH PRIVILEGES;
/** 查看账号权限 **/
show grants for 'canal'@'%%';
```

- 参考: https://www.jianshu.com/p/9759cd0f0614
- 参考: https://www.cnblogs.com/liuxuebagaomizhe/p/13809317.html