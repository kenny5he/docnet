contens：html
anchor：cnnsi.com
anchor:my.look.ca
mime:type


userid1  
上午 浏览页面 ：  
	web1 ：类目（category） 体育
	web2：财经
	web3：体育
	web？

userid2  view 
	web1：体育
	web5：军事
	web6：军事
	web7：体育
	web8：财经
	web9：娱乐
	web？

晚上
userid1： 体育，财经
userid2： 娱乐，财经 -》找娱乐和财经的新闻（剔除看过的）-》时间做降序排列-》推荐（10）


hive 一条数据10列
hbase 10条

999
[1-1000]

1:1-100 ,2:100-200,3:200-300....10:900-1000
10+99=109

1.在hbase上已经有数据了，我们需要将数据放到hive中进行分析处理：

create external table test2(key string,name string,age string,sex string)
stored by 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
with serdeproperties("hbase.columns.mapping"=":key,user:name,user:age,user:sex")
tblproperties("hbase.table.name"="test1");

查询看表是否有对应的数据：
set hive.cli.print.header=true;
select * from test2;

2.将hive中的数据【通过spark写入到hbase】中：





