### 语法:
1. 表达式

|表达式|说明|
| --- | --- |
| article | 选取所有article元素的所有子节点|
| /article	| 选取根元素article |
| article/a	| 选取所有属于article的子元素的a元素 |
| //div | 选取所有div元素(任何地方) |
| article//div | 选取所有属于article元素的后代的div元素 |
| //@class | 选择所有名为class的属性 |
| /article/div[1] | 选取属于article子元素的第一个元素 |
| /article/div[last()] | 选取属于article子元素的最后一个元素 |
| /article/div[last()-1] | 选取属于article子元素的倒数第二个元素 |
| //div[@lang] | 选取拥有lang属性的div元素 |
| //div[@lang='eng'] | 选取所有lang属性为eng的div元素 |
	
2. 函数

| 函数 | 说明 |
| --- | --- |
| //span[contains(@class,'someclass')] | 选取所有class属性包含someclass的span元素 |
| starts-with()| |
| text()| |
| //input[@name=‘identity’ and not(contains(@class,‘a’))] | 不匹配|
	
css选择器( 文档: http://www.runoob.com/cssref/css-selectors.html)
	response.css("body .container .grid .srId a::text").extract()	