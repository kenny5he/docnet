## Mysql Function
### Mysql 函数应用
1. 查询Mysql 函数信息
```
select * from mysql.proc where db = 'example' and type ='function';
/* 或 */
show function status where db = 'example';
```
#### 通过 Mysql 执行动态表达式函数

- https://www.cnblogs.com/freewing/p/5784154.html
