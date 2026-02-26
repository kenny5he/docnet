## Mysql 执行过程
![Mysql执行过程](workspace/git/worknotes/docnet/Database/mysql/imgs/sql.execute.flow.webp)
### MYSQL Server 层
1. 连接器 
2. 分析器
3. 优化器
4. 执行器
### MYSQL 存储层

Mysql 存储引擎层负责数据的存储和提取,架构模式是插件式的
#### MyISAM

#### InnoDB