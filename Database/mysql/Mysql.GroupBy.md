## Mysql 数据分组
### Group By

### Partition
1. 根据 Category 分组，并根据价格排序
```sql
select 
    row_number() over (partition by category order by price desc) as row_num,
    id,
    category,
    name,
    price,
from goods;
```
2. 根据 Category 分组，并只取分组价格最高的那一条
```sql
select * from (
    select 
        row_number() over (partition by category order by price desc) as rn,
        id,
        category,
        name,
        price,
    from goods
) as a1 
where a1.rn = 1;
```