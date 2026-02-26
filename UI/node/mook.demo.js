/* 创建一个服务器 */
const http = require('http');
const hostname = '127.0.0.1';
const port = 3000;
const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World\n');
});
server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});


/* 模块 */
	/**创建一个模块 student.js**/
	function add(student){
		console.log('Add Student:'+student);
	}
	/**
	 * exports是module.exports的幅度方法，最终返回module.exports,
	 * module.exports已有属性,export将不生效
	 */
	/* module.exports = add */
	exports.add = add/*传统实例,常用*/
	
	/**导入一个模块**/
	var student = require('./student')
	student.add('Scott')
	
