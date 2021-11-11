//官方文档: https://docs.mongodb.com/master/reference/method/db.updateUser/
创建用户并添加权限:
	db.createUser({user:"root",pwd:"mgdb.123",roles:[{role:"userAdminAnyDatabase",db:"admin"}]})
	权限:
		1. 数据库用户角色：read、readWrite;
	    2. 数据库管理角色：dbAdmin、dbOwner、userAdmin；
	    3. 集群管理角色：clusterAdmin、clusterManager、clusterMonitor、hostManager；
	    4. 备份恢复角色：backup、restore；
	    5. 所有数据库角色：readAnyDatabase、readWriteAnyDatabase、userAdminAnyDatabase、dbAdminAnyDatabase
	    6. 超级用户角色：root  
	    		// 这里还有几个角色间接或直接提供了系统超级用户的访问（dbOwner 、userAdmin、userAdminAnyDatabase）
	    7. 内部角色：__system
查看已存在的用户:
	db.system.users.find()
修改用户信息:
	db.updateUser("root",{roles:[{role:"root",db:"admin"}]})
	
修改用户密码:
	db.changeUserPassword("root","microfoolish.123");
开启认证模式:
	mongod -f /etc/mongod.conf --fork --auth 	