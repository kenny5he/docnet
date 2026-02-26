### 批量插入表数据
1. insert select
    1. 格式
    ```
    /** 1.复制表1 数据到表2中 */
    INSERT INTO table1(field1,field2,field3,field4,field5)
    select  a.field1,a.field2,a.field3,b.field4,b.field5 from table2  as a
    left join  table3 as b on a.filed = b.filed
    where -- 写条件
    ```
    2. 案例
    ```sql
    INSERT INTO sys_menu_copy
        (parent_id, name, url, perms, `type`, icon, order_num, default_name)
    SELECT 
        parent_id, name,url, perms, `type`, icon, order_num, default_name 
    FROM sys_menu 
    where menu_id =1
    ```