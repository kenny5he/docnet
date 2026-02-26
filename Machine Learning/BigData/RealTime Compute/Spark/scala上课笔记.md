spark-env.sh
export SCALA_HOME=/usr/local/src/scala-2.11.8
export JAVA_HOME=/usr/local/src/jdk1.7.0_67
export HADOOP_HOME=/usr/local/src/hadoop-2.6.1
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export SPARK_LOCAL_DIRS=/usr/local/src/spark-2.0.2-bin-hadoop2.6
export SPARK_MASTER_IP=master
export SPARK_DRIVER_MEMORY=2G

从节点查看 vim /etc/hosts
spark_home->conf->slaves

vim ~/.bashrc
export SCALA_HOME=/usr/local/src/scala-2.11.8
export SPARK_HOME=/usr/local/src/spark-2.0.2-bin-hadoop2.6
export PATH=$SPARK_HOME/bin:$SCALA_HOME/bin:$HIVE_HOME/bin:$PATH

driver 2g
collect 满了 oom

一、scala  word count
1.先将数据导入到scala
import scala.io.Source
val lines = Source.fromFile("./The_Man_of_Property.txt").getLines().toList

共2866行数据，需要对【每一行】数据进行【单词的切割】（提取单词）
map split

lines.map(x=>x.split(" "))
lines.map(_.split(" ")) 
返回还是list（Array（），Array（））

flatten: 数组打平
lines.map(x=>x.split(" ")).flatten
lines.flatMap(x=>x.split(" "))

[ lines.flatMap(_.split(" ")) ]

List（word）

#flatMap
s1.map(_.map(_*2))
List(Vector(0, 2, 4, 6, 8), Vector(0, 2, 4, 6, 8), Vector(0, 2, 4, 6, 8))
s1.flatMap(_.map(_*2))
List[Int] = List(0, 2, 4, 6, 8, 0, 2, 4, 6, 8, 0, 2, 4, 6, 8)

MR wordcount的map reduce
lines.flatMap(_.split(" ")).map((_,1))

Preface,1
The,1
Forsyte,1
Saga,1

lines.flatMap(_.split(" ")).map((_,1)).groupBy(_._1)
从tuple(forgotten,1)中把第一个单词提出来forgotten作为key，
把整个tuple作为value，收集到一个list中
这样对应的value是一个list里面包含所有对应key的tuple
例：
_1:forgotten -> _2:List((forgotten,1), (forgotten,1), (forgotten,1))

整个list大小就是对应key：forgotten出现的次数
lines.flatMap(_.split(" ")).map((_,1)).groupBy(_._1).map(x=>(x._1,x._2.length))
lines.flatMap(_.split(" ")).map((_,1)).groupBy(_._1).map(x=>(x._1,x._2.size))

如果不通过list大小来算具体单词的次数（词频）
就像要讲map中的list中的第二个值相加

其中数组求和的方式：
1）、a1.map(_._2).sum
2）、a1.map(_._2).reduce(_+_)
reduce(_+_)计算原理：
 List(1, 1, 1) ((1+1)+1)
 sum += x
 
lines.flatMap(_.split(" ")).map((_,1))
	.groupBy(_._1)
	.map(x=>(x._1,x._2.map(_._2).sum))
因为x._2是一个list所以对里面的求和，就是数组的一个求和

baseline先出来

需求：我们需要统计出来单词里面按照词频取topN
top我们就需要排序：
sortBy()，从小到大的排序
我们需要降序的排列
sortBy(_._2).reverse == sortWith(_._2>_._2)
_._2表示按照第二个进行排序

topN：取前N个值
需要进行数组的切片：
指定返回数组中的多少个数
top10: slice(0,10)

baseline：
lines.flatMap(_.split(" "))
	.map((_,1)).groupBy(_._1)
	.map(x=>(x._1,x._2.size))
	.toList.sortBy(_._2).reverse
	.slice(0,10)

	
lines.flatMap(_.split(" "))
	.map((_,1))
	.groupBy(_._1)
	.mapValues(_.size)
返回的是一个Map（dict）,key：单词，value：词频

lines.flatMap(_.split(" "))
	.map((_,1))
	.groupBy(_._1)
	.mapValues(_.size)
	.toArray
	.sortWith(_._2>_._2)
	.slice(0,10)

	
def f(){}
lines.map(f)
	
a.foldLeft(0)(_+_)

sum = 0
for i in a:
	sum += i
return sum

tuple求和
sum = 0
for i in a:
	sum += i[1]
return sum

a.foldLeft(0)(_+_._2)
	
正则：
python  import re
p = r'[0-9]+'
p.findall(s)这个是一个数组
p.findall(s)[0]

scala：
val p = "[0-9]+".r
val s = "546465sfgidg"
p.findAllIn(s).toArray

p.findAllIn(s).foreach(x=>println(x))

p.findAllIn(s).mkString("")
mkString("[","","]")
取标点，只取数字和字符
val p = "[0-9a-zA-Z]+".r
lines.flatMap(_.split(" "))
	.map(x=>(p.findAllIn(x).mkString(""),1))
	.groupBy(_._1)
	.mapValues(_.size)
	.toArray
	.sortWith(_._2>_._2)
	.slice(0,10)

lines.flatMap(_.split(" ")).map(x=>(p.findAllIn(x).mkString(""),1))
