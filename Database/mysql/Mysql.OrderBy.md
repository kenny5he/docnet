# Mysql Order by 
1. Order by 使用方式
    1. 按字段自然规则排序 (数学方法 -> 从小到大, 字母 a->z ,时间 -> 从小到大)
        ```sql
        select * from order o order by o.id 
        ```
    2. 按自定义规则排序
        ```sql
        select * from order o order by field (o.state,1,0,2,-1,3) 
        ```