# 数据库备份
1. 数据库备份目的:
   1. 灾难恢复: 硬件故障、alter table/truncate table(修改表结构、删除表)
   2. 审计: 数据审计
   3. 黑客入侵
2. 数据库备份类别
   1. 根据逻辑/物理 备份方式区分
      1. 逻辑备份
      2. 物理备份
   2. 根据在线/离线 备份区分
      1. 在线备份
      2. 离线备份
   3. 根据全量/增量 备份范围区分
      1. 全量备份
      2. 增量备份
3. 备份工具
   1. PerconaXtraBackup (Mysql/MongoDB/PostgreSQL)
   2. MySql 

# 数据库恢复
   