### 数据备份 (SQL篇)
#### 简单的数据备份(指定单据)
```sql
create table cs_ola_record_t_20230315 as(
    select * from cs_ola_time_record_t
        where union_member in ('2901263','1902039');
)
```