contens��html
anchor��cnnsi.com
anchor:my.look.ca
mime:type


userid1  
���� ���ҳ�� ��  
	web1 ����Ŀ��category�� ����
	web2���ƾ�
	web3������
	web��

userid2  view 
	web1������
	web5������
	web6������
	web7������
	web8���ƾ�
	web9������
	web��

����
userid1�� �������ƾ�
userid2�� ���֣��ƾ� -�������ֺͲƾ������ţ��޳������ģ�-��ʱ������������-���Ƽ���10��


hive һ������10��
hbase 10��

999
[1-1000]

1:1-100 ,2:100-200,3:200-300....10:900-1000
10+99=109

1.��hbase���Ѿ��������ˣ�������Ҫ�����ݷŵ�hive�н��з�������

create external table test2(key string,name string,age string,sex string)
stored by 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
with serdeproperties("hbase.columns.mapping"=":key,user:name,user:age,user:sex")
tblproperties("hbase.table.name"="test1");

��ѯ�����Ƿ��ж�Ӧ�����ݣ�
set hive.cli.print.header=true;
select * from test2;

2.��hive�е����ݡ�ͨ��sparkд�뵽hbase���У�





