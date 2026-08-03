## Mysql 数据分组
### Group By
```sql
select 
    count(0) as `count`,
    invoice_number,
    invoice_code,
    doc_type
from t_etp_group_relation
where (invoice_number, doc_type) in (('1347684543','pdf'),('77353189832431', 'pdf'))
group by invoice_number
```

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