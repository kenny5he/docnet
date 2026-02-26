## Oracle 立即执行
1. 给动态语句传值
```sql
declare   
   l_depnam  varchar2(20) := 'testing';   
   l_loc     varchar2(10) := 'D?i';   
   begin   
   execute immediate 'insert into dept vals   (:1, :2, :3)'   
     using 50, l_depnam, l_loc;   
   commit;   
end;
```
2. 给动态语句查询检索
```sql
declare   
   l_count  varchar2(20);
begin
execute immediate 'select count(1) from emp'   
     into l_cnt;
dbms_output.put_line(l_count);
end;
```
- 参考: https://www.cnblogs.com/xwb583312435/p/9056263.html