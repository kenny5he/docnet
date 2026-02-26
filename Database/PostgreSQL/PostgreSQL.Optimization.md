### PG数据库优化
1. 表实际数据不为0,表统计信息为0(表行数为0)，查询数据不走索引
    - 解决方案：
      1. 检查统计信息
      ```sql
        select * from pg_stat_all_tables;
      ```
      2. 更新统计信息
      ```sql
        vacuum analyse <table>
      ```
