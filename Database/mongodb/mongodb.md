monogodb(No SQL)

1.创建一个数据库
	use[databaseName]
	如果你什么也不干就离开的话这个空数据库就会被删除	

2.查看所有数据库
	show dbs

3.给指定数据库添加集合
	use foobar --建立一个叫 foobar 的数据库
	db.persons.insert({name:"uspcat"}) 给数据库创建一个集合 persons 为这个集合添加一条数据

4.查看数据库中的所有文档
	show collections

5.查询指定文档的数据
	查询所有 db.[documentName].find() //例:db.system.indexes.find()
	查询第一条数据 db.[documentName].findOne() //例：db.system.indexes.findOne()

6.更新文档数据
	db.[documentName].update({查询条件},{更新内容})//不加其它操作只更新第一条数据
例1:
	var p = db.persons.findOne()
	db.persons.update(p,{name:"uspcat"})
例2:
	db.persons.update({name:"uspcat"},{$set:{name:"extjs4.0"}})//把persons集合中name为uspcat 的数据改为 name为 extjs4.0

7.删除文档数据
	db.[documentName].remove({})
	例：db.persons.remove({name:"extjs4.0"})

8.删除库中的集合
	db.[documentName].drop()
	例：db.persons.drop() 查看是否删除集合：show collections

9.删除数据库
	db.dropDatabase()
	查看是否删除数据库:show dbs

10.Shell的help
	里面所有的shell可以完成的命令帮助
	全局的help 数据库相关的db.help()集合相关的db.[documentName].help()
例：	db.help()--数据库帮助
	db.persons.help()--获取集合帮助
	db.getName()--获取数据库名称
	db.stats()--获取数据库状态

11.mongoDB的API
	http://api.mongodb.org.js/2.1.2/index.html

数据库和集合命名规范
	1.不能是空字符串
	2.不能含有''(空格)、,、$、/、\、和\o（空字符）
	3.全部应小写
	4.最多64个字节
	5.数据库名不能与现有系统保留库同名，如admin,local及config
这样的集合名字也是合法的
	db-text但是不能通过db.[documentName]得到的 
	要改为db.getCollection(documentName)
	因为db-text会被当成是减法操作

mongoDB的shell内置JavaScript引擎可以直接执行JS代码
	function insert(object){
		db.getCollection("db-text").insert(object)
	}
	insert({age:32})

shell可以用eval
	db.eval("mongodb")
	
BSON是JSON的扩展他新增了诸如日期浮点等JSON不支持的数据类型


插入文档
	  
	db.[documentName].insert({})

批量插入文档
         
	shell 这样执行是错误的 db.[documentName].insert([{},{},{}……..])
         shell 不支持批量插入
	想完成批量插入可以用mongo的应用驱动或是shell的for循环

Save操作
          
	save操作和insert操作区别在于当遇到_id相同的情况下
	save完成保存操作

        insert则会报错

删除列表中所有数据

	db.[documentName].remove()
        集合的本身和索引不会别删除

根据条件删除

        db.[documentName].remove({})

	删除集合text中name等于uspcat的纪录

        db.text.remove({name:”uspcat”})
小技巧        
	如果你想清除一个数据量十分庞大的集合直接删除该集合并且重新建立索引的办法比直接用remove的效率和高很多

强硬的文档替换式更新操作

	db.[documentName].update({查询器},{修改器})
	 强硬的更新会用新的文档代替老的文档

主键冲突的时候会报错并且停止更新操作
 
        因为是强硬替换当替换的文档和已有文档ID冲突的时候
  
        则系统会报错

insertOrUpdate操作
 
        目的:查询器查出来数据就执行更新操作,查不出来就替换操作

	做法:db.[documentName].update({查询器},{修改器},true)

批量更新操作
 
        默认情况当查询器查询出多条数据的时候默认就修改第一条数据
 
        	如何实现批量修改
 
        db.[documentName].update({查询器},{修改器},false, true)

使用修改器来完成局部更新操作
修改器名称		语法			  	   案例	  					注释

  $set	     { $set:{field: value} }	         { $set:{name:”uspcat”}}		  它用来指定一个键值对,如果存在键就进行修改不存在则进行添加.

  $inc	    { $inc : { field : value } }         { $inc : { "count" : 1 } }		  只是使用与数字类型,他可以为指定的键对应的数字类型的数值进行加减操作.

 $unset    { $unset : { field : 1} }	         $unset : { “name":1 }			  就是删除指定的键

 $push	{ $push : { field : value } }	         { $push : { books:”JS”}
1.如果指定的键是数组增追加新的数值

2.如果指定的键不是数组则中断当前操作Cannot apply $push/$pushAll modifier to non-array

3.如果不存在指定的键则创建数组类型的键值对

 $pushAll  { $pushAll : { field : array } }    { $push : { books:[“EXTJS”,”JS”]}	  用法和$push相似他可以体谅添加数组数据

  $addToSet { $addToSet: { field : value } }    { $addToSet: { books:”JS”}		  目标数组存在此项则不操作,不存在此项则加进去

  $pop	    {$pop:{field: value}}		{$pop:{name:1}} {$pop:{name:-1}}	  从指定数组删除一个值1删除最后一个数值,-1删除第一个数值

  $pull	    { $pull: { field : value } }	{ $pull : { “book" : “JS” } } 	  删除一个被指定的数值

 $pullAll  { $pullAll: { field : array} }	{ $pullAll: { “name":[“JS”,”JAVA”] } 一次性删除多个指定的数值

 $	    { $push : { field : value } }	{ $push : { books:”JS”}
1.数组定位器,如果数组有多个数值我们只想对其中一部分进行操作我们就要用到定位器($)	
	例子:
例如有文档{name:”YFC”,age:27,books:[{type:’JS’,name:”EXTJS4”},{type:”JS”,name:”JQUERY”},{type:”DB”,name:”MONGODB”}]}	
	我们要把type等于JS的文档增加一个相同的作者author是USPCAT
办法:
db.text.update({"books.type":"JS"},{$set:{"books.$.author":"USPCAT"}})

$addToSet与$each结合完成批量数组更新
	db.text.update({_id:1000},{$addToSet:{books:{$each:[“JS”,”DB”]}}})
 
        $each会循环后面的数组把每一个数值进行$addToSet操作
存在分配与查询效率
	 
	当document被创建的时候DB为其分配没存和预留内存当修改操作
，不超过预留内层的时候则速度非常快反而超过了就要分配新的内存
，则会消耗时间

runCommand函数和findAndModify函数
	 
	runCommand可以执行mongoDB中的特殊函数
	 
	findAndModify就是特殊函数之一他的用于是返回update或remove后的文档
 	
	
	runCommand({
		“findAndModify”:”processes”, 
      		query:{查询器},

		sort{排序},		
		new:true,		
		update:{更新器},		
		remove:true
      
	 }).value
        

	ps = db.runCommand({
              
 		"findAndModify":"persons",
               
		"query":{"name":"text"},
		     
		"update":{"$set":{"email":"1221"}},
		      "
		"new":true 	
	}).value


	do_something(ps)


查询

指定返回的键
	  
db.[documentName].find ({条件},{键指定})
        
	1.1 查询出所有数据的指定键(name ,age ,country)
		
	db.persons.find({},{name:1,age:1,country:1,_id:0})
查询条件	
    		比较操作符
	$lt	<	{age:{$gte:22,$lte:27}}
	$lte	<=	
	$gt	>	
	$gte	>=	
	$ne	!=	{age:{$ne:26}}
	
		案例
	2.2.1查询出年龄在25到27岁之间的学生
 
       		db.persons.find({age: {$gte:25,$lte:27},{_id:0,age:1})
       
	2.2.2查询出所有不是韩国籍的学生的数学成绩     
		db.persons.find({country:{$ne:” Korea”}},{_id:0,m:1})
3.包含或不包含
       $in或$nin
       
	2.3.1查询国籍是中国或美国的学生信息

      		db.persons.find({country:{$in:[“USA”,“China”]}})
       
	2.3.2查询国籍不是中国或美国的学生信息
	        db.persons.find({country:{$nin:[“USA”,“China”]}})
4.OR查询
	$or
       
	2.4查询语文成绩大于85或者英语大于90的学生信息
        	db.persons.find({$or:[{c:{$gte:85}},{e:{$gte:90}}]},{_id:0,c:1,e:1})
5.Null
      
	把中国国籍的学生上增加新的键sex
      
		db.person.update({country:”China”},{$set:{sex:”m”}})
      
	2.5查询出sex 等于 null的学生        	
		db.persons.find({sex:{$in:[null]}},{country:1})
6.正则查询
       
	2.6查询出名字中存在”li”的学生的信息
	        db.persons.find({name:/li/i},{_id:0,name:1}) 

7.$not的使用
	$not可以用到任何地方进行取反操作
    
	2.7查询出名字中不存在”li”的学生的信息
 
 	        db.persons.find({name:{$not:/li/i}},{_id:0,name:1})
 
	 	$not和$nin的区别是$not可以用在任何地方儿$nin是用到集合上的
8.数组查询$all和index应用 	
	2.8.1查询喜欢看MONGOD和JS的学生
 
       	db.persons.find({books:{$all:[“MONGOBD”,”JS”]}},{books:1,_id:0})
 
       2.8.2查询第二本书是JAVA的学习信息
	
        db.persons.find({“books.1”:”JAVA”})

9.查询指定长度数组$size它不能与比较查询符一起使用(这是弊端)

        2.9.1查询出喜欢的书籍数量是4本的学生
 
       	db.persons.find({books:{$size:4}},{_id:0,books:1})
       
	2.9.2查询出喜欢的书籍数量大于3本的学生
	
        1.增加字段size
	    
	 		db.persons.update({},{$set:{size:4}},false, true)	        
		2.改变书籍的更新方式,每次增加书籍的时候size增加1
	
        	db.persons.update({查询器},{$push:{books:”ORACLE”},$inc:{size:1}})	        
		3.利用$gt查询	        
			db.persons.find({size:{$gt:3}})
	
        4.利用shell查询出Jim喜欢看的书的数量		
			var persons = db.persons.find({name:"jim"})
			
while(persons.hasNext()){	
				obj = persons.next();
		
       		print(obj.books.length)
			
} 
     
	课间小结               
		1.mongodb 是NOSQL数据库但是他在文档查询上还是很强大的

                2.查询符基本是用到花括号里面的更新符基本是在外面
 
                3.shell是个彻彻底底的JS引擎,但是一些特殊的操作要靠他的各个驱动包来完成(JAVA,NODE.JS)
       

10.$slice操作符返回文档中指定数组的内部值

        10.1查询出Jim书架中第2-4本书
       
		db.persons.find({name:"jim"},{books:{"$slice":[1,3]}})       
	10.2查询出最后一本书	        
		db.persons.find({name:"jim"},{books:{"$slice":-1},_id:0,name:1})

11.文档查询
      
	为jim添加学习简历文档 jim.json        
	11.1查询出在K上过学的学生	        
		1. 这个我们用绝对匹配可以完成,但是有些问题(找找问题?顺序?总要带着score?)
	
        	db.persons.find({school:{school:"K",score:"A"}},{_id:0,school:1})

      		2.为了解决顺序的问题我可以用对象”.”的方式定位
	
        	db.persons.find({"school.score":"A","school.school":"K"},{_id:0,school:1})
	
	3.这样也问题看例子:
	
 		db.persons.find({"school.score":"A","school.school":”J”},{_id:0,school:1})

          		同样能查出刚才那条数据,原因是score和school会去其他对象对比

      		4.正确做法单条条件组查询$elemMatch	        	
			db.persons.find({school:{$elemMatch:{school:"K",score:"A"}}})

12.$where
     
	12.查询年龄大于22岁,喜欢看C++书,在K学校上过学的学生信息

            		复杂的查询我们就可以用$where因为他是万能但是我们要尽量避免少使用它因为他会有性能的代价

	db.persons.find({"$where":function(){
		var books = this.books;
		var school = this.school;
		if(this.age>22){
			var php = null;
			for( var i =0; i<books.length; i++){
				if(books[i]=="C++"){
					php = books[i];
					if(school){
						for(var j =0;j < school.length;j++){
							if(school[j].school == "K"){
								return true;
							}
						}
						break;
					}
				}
			}
		}
	}})

1.Limit返回指定的数据条数
	1.1查询出persons文档中前5条数据

		db.persons.find({},{_id:0,name:1}).limit(5)

2.Skip返回指定数据的跨度
	2.1查询出persons文档中5~10条的数据
		db.persons.find({},{_id:0,name:1}).limit(5).skip(5)

3.Sort返回按照年龄排序的数据[1,-1]

	db.persons.find({},{_id:0,name:1,age:1}).sort({age:1})

   注意:mongodb的key可以存不同类型的数据排序就也有优先级
	最小值
    null
    数字
    字符串
    对象/文档
    数组
    二进制
    对象ID
    布尔
    日期
     时间戳  正则  最大值  


4.Limit和Skip完成分页
    
	4.1三条数据位一页进行分页

        	第一页db.persons.find({},{_id:0,name:1}).limit(3).skip(0)

          	第二页db.persons.find({},{_id:0,name:1}).limit(3).skip(3)
	4.2skip有性能问题,没有特殊情况下我们也可以换个思路对文档进行重新解构设计

		每次查询操作的时候前后台传值全要把上次的最后一个文档的日期保存下来
db.persons.find({date:{$gt:日期数值}}).limit
	4.3
个人建议:应该把软件的中点放到便捷和精确查询上而不是分页的性能上
因为用户最多不会翻查过2页的


1.游标
    
	利用游标遍历查询数据

		var  persons = db.persons.find();
		while(persons.hasNext()){
	
		obj = persons.next();
	
        	print(obj.name)
     
		} 

2.游标几个销毁条件
	1.客户端发来信息叫他销毁

	2.游标迭代完毕
	3.默认游标超过10分钟没用也会别清除

3.查询快照

	快照后就会针对不变的集合进行游标运动了,看看使用方法.
		db.persons.find({$query:{name:”Jim”},$snapshot:true})
    
	高级查询选项

    	$query
    $orderby
    
		$maxsan：integer 最多扫描的文档数

    	$min：doc  查询开始

    	$max：doc  查询结束

    	$hint：doc 使用哪个索引

    	$explain:boolean  统计

    	$snapshot:boolean 一致快照



1.创建简单索引
  数据准备index.js
        
	1.先检验一下查询性能

            var start = new Date()

            db.books.find({number:65871})
 
            var end = new Date()
 
            end - start

        2.为number 创建索引
 
            db.books.ensureIndex({number:1})

        3.再执行第一部的代码可以看出有数量级的性能提升
2.索引使用需要注意的地方
         
	1.创建索引的时候注意1是正序创建索引-1是倒序创建索引

        2.索引的创建在提高查询性能的同事会影响插入的性能
            
	对于经常查询少插入的文档可以考虑用索引
         
	3.符合索引要注意索引的先后顺序
         
	4.每个键全建立索引不一定就能提高性能呢，索引不是万能的
         
	5.在做排序工作的时候如果是超大数据量也可以考虑加上索引
，用来提高排序的性能


3.索引的名称
    
	3.1用VUE查看索引名称
	3.2创建索引同时指定索引的名字

        	db.books.ensureIndex({name:-1},{name:”bookname”})

4.唯一索引
     
	4.1如何解决文档books不能插入重复的数值
，建立唯一索引
           
		db.books.ensureIndex({name:-1},{unique:true})
           
	     试验

	        db.books .insert({name:”1book”})



5.踢出重复值
  
      5.1如果建议唯一索引之前已经有重复数值如何处理

	        db.books.ensureIndex({name:-1},{unique:true,dropDups:true})

6.Hint

        6.1如何强制查询使用指定的索引呢?

                db.books.find({name:"1book",number:1}).hint({name:-1})
		指定索引必须是已经创建了的索引



7.Expain

        7.1如何详细查看本次查询使用那个索引和查询数据的状态信息

 	       db.books.find({name:"1book"}).explain()













              “cursor” : “BtreeCursor name_-1“ 使用索引

              “nscanned” : 1 查到几个文档

              “millis” : 0 查询时间0是很不错的性能


1.system.indexes
        
	1.1在shell查看数据库已经建立的索引

               db.system.indexes.find()

               db.system.namespaces.find()
2.后台执行

        2.1执行创建索引的过程会暂时锁表问题如何解决?
 
              为了不影响查询我们可以叫索引的创建过程在后台
 
              db.books.ensureIndex({name:-1},{background:true})

3.删除索引

        3.1批量和精确删除索引
 
              db.runCommand({dropIndexes : ”books” , index:”name_-1”})
 
              db.runCommand({dropIndexes : ”books” , index:”*”})

1.mongoDB提供强大的空间索引可以查询出一定范围的地理坐标.看例子

          准备数据map.json
    1.查询出距离点(70,180)最近的3个点
  
        添加2D索引

          db.map.ensureIndex({"gis":"2d"},{min:-1,max:201})
  
        默认会建立一个[-180,180]之间的2D索引
  
        查询点(70,180)最近的3个点

          db.map.find({"gis":{$near:[70,180]}},{gis:1,_id:0}).limit(3)

    2.查询以点(50,50)和点(190,190)为对角线的正方形中的所有的点

          db.map.find({gis:{"$within":{$box:[[50,50],[190,190]]}}},{_id:0,gis:1})
    
3.查询出以圆心为(56,80)半径为50规则下的圆心面积中的点

          db.map.find({gis:{$within:{$center:[[56,80],50]}}},{_id:0,gis:1})

1.Count

    请查询persons中美国学生的人数.

    	db.persons.find({country:"USA"}).count()

2.Distinct

    请查询出persons中一共有多少个国家分别是什么.

	db.runCommand({distinct:"persons“ , key:"country"}).values

3.Group
    3.1语法:

        db.runCommand({group:{

	           ns:集合名字,
		   
Key:分组的键对象,

		   Initial:初始化累加器,
		   
$reduce:组分解器,
		   
Condition:条件,
		   
Finalize:组完成器

        }})

     分组首先会按照key进行分组,每组的 每一个文档全要执行$reduce的方法,
 
     他接收2个参数一个是组内本条记录,一个是累加器数据.

     3.2请查出persons中每个国家学生数学成绩最好的学生信息(必须在90以上)
   

	db.runCommand({group:{

		ns:"persons",
key:{"country":true},
		
initial:{m:0},

		$reduce:function(doc,prev){

			if(doc.m > prev.m){

				prev.m = doc.m;

				prev.name = doc.name;

				prev.country = doc.country;

			}

		},
condition:{m:{$gt:90}}
}})
     

3.3在3.1要求基础之上吧没个人的信息链接起来写一个描述赋值到m上
	
finalize:function(prev){
 
		prev.m = prev.name+" Math scores "+prev.m

	}

4.用函数格式化分组的键
     4.1如果集合中出现键Counrty和counTry同时存在那分组有点麻烦这要如何解决呢?

        $keyf:function(doc){

                return {country:doc.counTry}

        },…..

1.命令执行器runCommand

        1.1用命令执行完成一次删除表的操作
db.runCommand({drop:"map"})
{

        "nIndexesWas" : 2,

        "msg" : "indexes dropped for collection",

        "ns" : "foobar.map",

        "ok" : 1
}

2.如何查询mongoDB为我们提供的命令
  
      1.在shell中执行 db.listCommands()

        2.访问网址http://localhost:28017/_commands

3.常用命令举例
 
       3.1查询服务器版本号和主机操作系统

	        db.runCommand({buildInfo:1})

        3.2查询执行集合的详细信息,大小,空间,索引等……
	        db.runCommand({collStats:"persons"})

        3.3查看操作本集合最后一次错误信息

        	db.runCommand({getLastError:"persons"})


2.固定特性

        2.1固定集合默认是没有索引的就算是_id也是没有索引的

        2.2由于不需分配新的空间他的插入速度是非常快的

        2.3固定集合的顺是确定的导致查询速度是非常快的

        2.4最适合的是应用就是日志管理

3.创建固定集合

        3.1创建一个新的固定集合要求大小是100个字节,可以存储文档10个

             db.createCollection("mycoll",{size:100,capped:true,max:10})

        3.2把一个普通集合转换成固定集合

             db.runCommand({convertToCapped:”persons”,size:100000})

4.反向排序,默认是插入顺序排序.

        4.1查询固定集合mycoll并且反响排序

             db.mycoll.find().sort({$natural:-1})

5.尾部游标,可惜shell不支持java和php等驱动是支持的

        5.1尾部游标概念

             这是个特殊的只能用到固定级和身上的游标,他在没有结果的时候

             也不回自动销毁他是一直等待结果的到来
1.概念

          GridFS是mongoDB自带的文件系统他用二进制的形式存储文件

          大型文件系统的绝大多是特性GridFS全可以完成

2.利用的工具



3.使用GridFS

          3.1查看GridFS的所有功能

           cmdmongofiles

          3.2上传一个文件

           mongofiles -d foobar -l "E:\a.txt" put "a.txt“

          3.3查看GridFS的文件存储状态

                利用VUE查看
   





                集合查看

                db.fs.chunks.find() 和db.fs.files.find() 存储了文件系统的所有文件信息


	  3.4查看文件内容

     		C:\Users\thinkpad>mongofiles -d foobar get "a.txt“

     		VUE可以查看,shell无法打开文件

	  3.5查看所有文件

     		mongofiles -d foobar list

	  3.5删除已经存在的文件VUE中操作

     		mongofiles -d foobar delete 'a.txt'

1.Eval

    1.1服务器端运行eval

          db.eval("function(name){ return name}","uspcat")

2.Javascript的存储

    2.1在服务上保存js变量活着函数共全局调用

          1.把变量加载到特殊集合system.js中

             db.system.js.insert({_id:name,value:”uspcat”})

          2.调用

             db.eval("return  name;")
System.js相当于Oracle中的存储过程,因为value不单单可以写变量
还可以写函数体也就是javascript代码

1.启动项 mongod --help
	--dbpath	指定数据库的目录,默认在window下是c:\data\db\
	--port	指定服务器监听的端口号码,默认是27017
	--fork	用守护进程的方式启动mongoDB
	--logpath	指定日志的输出路径,默认是控制台
	--config	指定启动项用文件的路径
	--auth	用安全认证方式启动数据库
    1.1利用config配置文件来启动数据库改变端口为8888

       mongodb.conf文件

       dbpath = D:\sortware\mongod\db
 
      port = 8888

       启动文件

       cd C:\Users\thinkpad\Desktop\MONGODB\mongodb-win32-x86_64-2.0.6

       bin\mongod.exe --config ../mongodb.conf

       shell文件

       mongo 127.0.0.1:8888
2.停止mongoDB服务

    1.1ctrl+c 组合键可以关闭数据库









    
1.2admin数据库命令关闭数据








1.导出数据(中断其他操作)

        打开CMD

        利用mongoexport

	           -d 指明使用的库
-c 指明要导出的表
-o 指明要导出的文件名
-csv 制定导出的csv格式
-q 过滤导出
--type <json|csv|tsv>

	 1.1把数据好foobar中的persons导出

	   	 mongoexport -d foobar -c persons -o D:/persons.json

         1.2导出其他主机数据库的文档

        	 mongoexport --host 192.168.0.16 --port 37017
2.导入数据(中断其他操作)

       		 API
        http://cn.docs.mongodb.org/manual/reference/mongoimport/

2.1到入persons文件

         ongoimport --db foobar --collection persons --file d:/persons.json
          



1.运行时备份mongodump

        API
       http://cn.docs.mongodb.org/manual/reference/mongodump/
	
	1.1导出127.0.0.1服务下的27017下的foobar数据库

	       mongodump --host 127.0.0.1:27017 -d foobar -o d:/foobar

2.运行时恢复mongorestore
 
       API
       http://cn.docs.mongodb.org/manual/reference/mongorestore/

       2.1删除原本的数据库用刚才导出的数据库恢复

       		db.dropDatabase()

       		mongorestore --host 127.0.0.1:27017 -d foobar -directoryperdb d:/foobar/foobar

3.懒人备份

       mongoDB是文件数据库这其实就可以用拷贝文件的方式进行备份
      


1.Fsync的使用
   
    先来看看mongoDB的简单结构

2.上锁和解锁

        上锁

             db.runCommand({fsync:1,lock:1});

        解锁

             db.currentOp()

3.数据修复

         当停电等不可逆转灾难来临的时候,由于mongodb的存储结构导致

         会产生垃圾数据,在数据恢复以后这垃圾数据依然存在,这是数据库

         提供一个自我修复的能力.使用起来很简单

         db.repairDatabase()




1.添加一个用户

     1.1为admin添加uspcat用户和foobar数据库的yunfengcheng用户

         use admin

         db.addUser(“uspcat”,”123”);

         use foobar

         db.addUser(“yunfengcheng”,”123”);

2.启用用户

         db.auth(“名称”,”密码”)

3.安全检查 --auth

        非foobar是不能操作数据库的






        启用自己的用户才能访问





	非admin数据库的用户不能使用数据库命令





        admin数据库中的数据经过认证为管理员用户







4.用户删除操作

        db.system.users.remove({user:"yunfengcheng"});



1.主从复制是一个简单的数据库同步备份的集群技术.

	1.1在数据库集群中要明确的知道谁是主服务器,主服务器只有一台.
	
1.2从服务器要知道自己的数据源也就是对于的主服务是谁.
	
1.3--master用来确定主服务器,--slave 和 –source 来控制曾服务器
1.主从复制集群案例
	dbpath = D:\sortware\mongod\01\8888
   	主数据库地址
port = 8888 主数据库端口号
bind_ip = 127.0.0.1
	主数据库所在服务器
master = true 确定我是主服务器

	dbpath = D:\sortware\mongod\01\7777   
	从数据库地址
port = 7777 
	从数据库端口号
bind_ip = 127.0.0.1 
	从数据库所在服务器
source = 127.0.0.1:8888 
	确定我数据库端口
slave = true 
	确定自己是从服务器

1.副本集概念
	1.1第一张图表明A是活跃的B和C是用于备份的

	1.2第二张图当A出现了故障,这时候集群根据权重算法推选出B为活跃的数据库

	1.3第三张图当A恢复后他自动又会变为备份数据库
1.副本集概念
	dbpath = D:\sortware\mongod\02\A
port = 1111  
	#端口
bind_ip = 127.0.0.1 
	#服务地址
replSet = child/127.0.0.1:2222 
	#设定同伴

	dbpath = D:\sortware\mongod\02\B

	port = 2222

	bind_ip = 127.0.0.1

	replSet = child/127.0.0.1:3333

	dbpath = D:\sortware\mongod\02\C

	port = 3333

	bind_ip = 127.0.0.1

	replSet = child/127.0.0.1:1111
2.初始化副本集
use admin
	
db.runCommand({"replSetInitiate":

	   {
      
		"_id":'child',
       
		"members":[{
	        
				"_id":1,
		
				"host":"127.0.0.1:1111"

            		},{
		
				"_id":2,
		
				"host":"127.0.0.1:2222"

	    		},{
		
				"_id":3,
		
				"host":"127.0.0.1:3333"

	   		 }]
    
	    }
	
})

2.查看副本集状态

	rs.status()

3.节点和初始化高级参数

     standard 常规节点:参与投票有可能成为活跃节点

     passive 副本节点:参与投票,但是不能成为活跃节点

     arbiter 仲裁节点:只是参与投票不复制节点也不能成为活跃节点

4.高级参数
Priority  
     0到1000之间 ,0代表是副本节点 ,1到1000是常规节点
arbiterOnly : true 仲裁节点
用法
members":[{
"_id":1,
"host":"127.0.0.1:1111“,
arbiterOnly : true
}]”

5.优先级相同时候仲裁组建的规则

6.读写分离操作扩展读

    6.1一般情况下作为副本的节点是不能进行数据库读操作的
 
          但是在读取密集型的系统中读写分离是十分必要的

    6.2设置读写分离

          slaveOkay :  true

          很遗憾他在shell中无法掩饰,这个特性是被写到mongoDB的

          驱动程序中的,在java和node等其他语言中可以完成
7.Oplog

          他是被存储在本地数据库local中的,他的每一个文档保证这一个节点操作

          如果想故障恢复可以更彻底oplog可已经尽量设置大一些用来保存更多的操作

          信息
	  改变oplog大小
 
	  主库--master --oplogSize  size


3.什么时候用到分片呢?

          3.1机器的磁盘空间不足
          3.2单个的mongoDB服务器已经不能满足大量的插入操作
  
        3.3想通过把大数据放到内存中来提高性能

4.分片步骤
  
        4.1创建一个配置服务器
  
        4.2创建路由服务器,并且连接配置服务器

              路由器是调用mongos命令

          4.3添加2个分片数据库

              8081和8082
          4.5利用路由为集群添加分片(允许本地访问)

	      db.runCommand({addshard:"127.0.0.1:8081",allowLocal:true})

	      db.runCommand({addshard:"127.0.0.1:8081",allowLocal:true})

              切记之前不能使用任何数据库语句
	  4.6打开数据分片功能,为数据库foobar打开分片功能

      	      db.runCommand({"enablesharding":"foobar"})




	  4.7对集合进行分片

              db.runCommand({"shardcollection":"foobar.bar","key":{"_id":1}})
	  



4.8利用大数据量进行测试 (800000条)  






    



5.查看配置库对于分片服务器的配置存储

          db.printShardingStatus()

6.查看集群对bar的自动分片机制配置信息
	  
mongos> db.shards.find()

		{ "_id" : "shard0000", "host" : "127.0.0.1:8081" }
		
{ "_id" : "shard0001", "host" : "127.0.0.1:8082" }

