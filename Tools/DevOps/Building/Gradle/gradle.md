1.groovy(依赖jdk，生成class文件) (1.完全兼容java语法，2.自动添加getter/setter，3.;号可选，4.==比较时不会抛出空指针异常)
	//可选类型定义(根据值自动推断类型，类似于javascript中的var)
	def version = 1
	//assert 任意地方可使用断言
	assert version == 2
	//括号可选
	println version
	//字符串(三种表达方式)
	def s1 = 'imooc'//仅仅是字符串
	def s2 = "gradle version is ${version}"//可插入变量
	def s3 = '''my name is
			 imooc'''//可换行
	//集合api
		//list
		def buildTools = ['ant','maven']
		buildTools << 'gradle' //增加
		assert buildTools.getClass == ArrayList
		
		//map
		def buildYears = ['ant':2000,'maven':2004]
		buildYears.gradle = 2009
		println buildYears.getClass()
		
	//闭包
	def c1 = {
		v ->
			print v
	}
	
	def c2 = {
		print 'hello'
	}
	def method1(Closure closure){
		closeure('param')
	}
	
	def method2(Closure closure){
		closeure()
	}
	method1(c1)
	method2(c2)
	
	//构建脚本中默认都是有个 Project实例的
	apply plugin:'java' //plugin 参数 值为 java
	version = '0.1' //Project 中属性 version 值 为0.1
	repositories { //repositories方法   {}闭包
		mavenCentral()
	}
	
	dependencies { //dependencies  {}闭包
		compile 'commons-codec:commons-codec:1.6'
	}
	
	//Gradle兼容maven  目录格式与maven一致
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	