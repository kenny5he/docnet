## 数据迁移脚本
```sql
create function select_incident_links(
    declare links_cusor cursor for
        select order_num from orders;

    
    
)
```