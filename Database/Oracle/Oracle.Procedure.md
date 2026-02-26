## 存储过程
1. 存储过程(Demo)
```oraclesqlplus
/** 1. 创建存储过程 **/
create or replace procedure demo_proc
is
  demotype demo1%rowtype;
begin
  select d1.* into demotype from demo1 d1 where d1.id=1;
end;
/** 2. 调用存储过程 **/
declare
begin
  demo_proc();
end;
```