# EMCAScript 6
## 常量
1. ES5中常量的写法
```javascript
Object.defineProperty(window,"PI1",{
    value: 3.1415926,
    writable: false //只读
})
```
2. ES6 写法
```javascript
const PI2 = 3.1415926;
```
## 作用域
1. ES5 无作用域
```javascript
var callbacks = []
for(var i = 0; i<=2;i++){
    // i * 2 返回出去看成一个表达式，而非具体值,
    // return 中包括变量 i,内存值被function引用,形成闭包 
    callbacks[i] = function(){
        return i * 2;
    }
}
console.table([
    callbacks[0](),
    callbacks[1](),
    callbacks[2]()
])
```
2. ES6 let声明作用域
```javascript
const callbacks = []
for(let i = 0; i<=2;i++){
    // 每循环一次 形成一个作用域
    // return 中包括变量 i,内存值被function引用,形成闭包 
    callbacks[i] = function{
        return i * 2;
    }
}
```
## 箭头函数	
1. ES5 函数
    1. 语法
	```javascript
    function fn(){}
    ```
    2. 案例
	```javascript
	var evens = [1,2,3,4,5];
	var odds = evens.map(function(v) {
		return v +1 
	})
	console.log(evens,odds);
    ```
2. ES6 箭头函数
	1. 语法
	    - 当只有一个传入参数时()可省略
	    - 当只有一个返回值时可省略{}
    ```javascript
    const fn = () => {}
	```
	2. 案例
    ```javascript
	let evens = [1,2,3,4,5];
	let odds = evens.map(v => v + 1)
	```

3. 箭头函数指向问题
    1. ES3 ES5 （this指向是该函数调用的指向）
    ```javascript
	var factory = function(){
		this.a = 'a';
		this.b = 'b';
		this.c = {
			a: 'a+',
			b: function(){
				return this.a
			}
		}
	}
    // 打印 a+ 
	console.log(new factory().c.b());
    ```
	2. ES6 （this指向是定义时函数的指向）
    ```javascript
	var factory = function(){
		this.a = 'a';
		this.b = 'b';
		this.c = {
			a: 'a+',
			b:() => { return this.a }
		}
	}
    // 打印 a
	console.log(new factory().c.b());
    ```

## 默认参数
1. ES3 ES5
    ```javascript
    function a(x,y,z){
        y = y || 1;
        z = z || 2;
        return x + y;
    }
    ```
2. ES6
    ```javascript
	fuction checkParameter() {
		throw new Error('Cant't be empty')
	}
	function b( x = checkParameter() , y = 1, z = 2){
		return x + y;
	}
    ```
## 可变参数
1. ES3 ES5
    ```javascript
	function sum(){
		var a = Array.prototype.slice.call(arguments);
		var sum = 0;
		a.forEach(function(item){
			sum += item*1;
		});
		return sum;
	}
    ```
2. ES6
    ```javascript
	function f(...a){
		var sum = 0;
		a.forEach(item=>{
			sum+=item*1
		});
		return sum;
	}
    ```
## 合并数组
1. ES5
    ```javascript
	var params = ['hello',true,7];
	var other = [1,2].concat(params);
	```
2. ES6
    ```javascript
	var params = ['hello',true,7];
	var other = [1,2, ...params];
   ```
	
## 对象代理(Proxy)
1. 作用: 保护对象中的属性读取访问，相当于java中的 private属性 通过get set方法控制实现
2. ES3
    ```javascript
	var Person = function(){
		var data = {
			name:'es3',
			sex: 'male',
			age: 15
		}
		this.get = function(key){
			return data[key]
		}
		this.set = function(key,value){
			if(key !== "sex"){
				data[key] = value
			}
		}
	}
    ```
3. ES5
    ```javascript
	var Person = {
		name : 'es5',
		age : 15
	};
	Object.defineProperty(Person,'sex',{
		writable:false,
		value:'male'
	});
    ```
4. ES6
    ```javascript
	let Person = {
		name : 'es6',
		sex : 'male',
		age : 15
	}
	
	let person = new Proxy(Person,{
		get(target,key){
			return target[key]
		}
		set(target,key,value){
			if(key!=='sex'){
				target[key]=value;
			}
		}
	})
    ```
## Reflect: 反射
1. 目的、作用:
    1. 将Object对象的一些明显属于语言内部的方法（比如Object.defineProperty），放到Reflect对象上。现阶段，
      某些方法同时在Object和Reflect对象上部署，未来的新方法将只部署在Reflect对象上。也就是说，从Reflect对象上可以拿到语言内部的方法
    2. 修改某些Object方法的返回结果，让其变得更合理。比如，Object.defineProperty(obj, name, desc)在无法定义属性时，会抛出一个错误，
      而Reflect.defineProperty(obj, name, desc)则会返回false
    3. 让Object操作都变成函数行为。某些Object操作是命令式，比如name in obj和delete obj[name]，
      而Reflect.has(obj, name)和Reflect.deleteProperty(obj, name)让它们变成了函数行为
    4. Reflect对象的方法与Proxy对象的方法一一对应，只要是Proxy对象的方法，就能在Reflect对象上找到对应的方法。
      这就让Proxy对象可以方便地调用对应的Reflect方法，完成默认行为，作为修改行为的基础。也就是说，不管Proxy怎么修改默认行为，你总可以在Reflect上获取默认行为
2. Method:
    1. Reflect.apply(target, thisArg, args)
        - 等同于Function.prototype.apply.call(func, thisArg, args)，用于绑定this对象后执行给定函数。
    2. Reflect.construct(target, args)
        - 等同于new target(...args)，提供了一种不使用new，来调用构造函数的方法
    3. Reflect.get(target, name, receiver)
        - 查找并返回target对象的name属性
        - 如果name属性部署了读取函数（getter），则读取函数的this绑定receiver
    4. Reflect.set(target, name, value, receiver)
        - 设置target对象的name属性等于value
        - 如果name属性设置了赋值函数，则赋值函数的this绑定receiver
    5. Reflect.defineProperty(target, name, desc)
        - 等同于Object.getOwnPropertyDescriptor，用于得到指定属性的描述对象
    6. Reflect.deleteProperty(target, name)
        - 等同于delete obj[name]，用于删除对象的属性
    7. Reflect.has(target, name)
        - 对应name in obj里面的in运算符，用于判断对象中是否存在name
        - target 不为对象则报错
    8. Reflect.ownKeys(target)
        - 用于返回对象的所有属性，基本等同于Object.getOwnPropertyNames与Object.getOwnPropertySymbols之和
    9. Reflect.isExtensible(target)
        - 对应Object.isExtensible，返回一个布尔值，表示当前对象是否可扩展。
    10. Reflect.preventExtensions(target)
        - 用于让一个对象变为不可扩展。它返回一个布尔值，表示是否操作成功。
    11. Reflect.getOwnPropertyDescriptor(target, name)
        - 等同于Object.getOwnPropertyDescriptor，用于得到指定属性的描述对象
    12. Reflect.getPrototypeOf(target)
        - 用于读取对象的__proto__属性，对应Object.getPrototypeOf(obj)。
    13. Reflect.setPrototypeOf(target, prototype)
        - 用于设置目标对象的原型（prototype），对应Object.setPrototypeOf(obj, newProto)方法
## Proxy
1. 案例
    1. 实现观察者模式:
        ```javascript
        const person = observable({
          name: '张三',
          age: 20
        });

        function print() {
          console.log(`${person.name}, ${person.age}`)
        }

        observe(print);
        person.name = '李四';

        const queuedObservers = new Set();

        const observe = fn => queuedObservers.add(fn);
        const observable = obj => new Proxy(obj, {set});

        function set(target, key, value, receiver) {
          const result = Reflect.set(target, key, value, receiver);
          queuedObservers.forEach(observer => observer());
          return result;
        }
        ```
## 解构赋值
1. 解构(Destructuring): 从数组和对象中提取值，对变量进行赋值,解构不成功则对应值为undefined.
        (只要某种数据结构具有 Iterator 接口，都可以采用数组形式的解构赋值,解构赋值允许指定默认值。)
2. ES3写法:
    ```javascript
        let a = 1;
        let b = 2;
        let c = 3;
    ```
3. ES6写法:
    1. 数组
         1. 顺序对应写法
            ```javascript
            // a = 1, b = 2, c = 3
            let [a, b, c] = [1, 2, 3]; 
            ```
        2. 解构默认值写法:
            ```javascript
            // x='a', y='b' 
            let [x, y = 'b'] = ['a']; 
            ```
    2. 对象:
        ```javascript
            //foo = "aaa" , bar = "bbb"
            let { foo, bar } = { foo: "aaa", bar: "bbb" }; 
        ```
    3. 字符串:
        ```javascript
            // a = 'h' , b = 'e' , c = 'l' ...
            const [a, b, c, d, e] = 'hello';
        ```
    4. 函数:
        1. 写法1:
            - 方法:
            ```javascript
                function move({x = 0, y = 0} = {}) {
                    return [x, y];
                }
            ```
            - 调用:
            ```javascript
                move({x: 3, y: 8}); // [3, 8]
                move({x: 3}); // [3, 0]
                move({}); // [0, 0]
                move(); // [0, 0]
            ```
        2. 写法2:
            1. 方法:(为函数move的参数指定默认值)
            ```javascript
                function move({x, y} = { x: 0, y: 0 }) {
                    return [x, y];
                }
            ```
            2. 调用:
            ```javascript
                move({x: 3, y: 8}); // [3, 8]
                move({x: 3}); // [3, undefined]
                move({}); // [undefined, undefined]
                move(); // [0, 0]
            ```
        3. 错误写法:(报错)
            ```javascript
           let [foo] = null;
            ```

## 模板字符串


## 正则扩展


## 函数扩展


## 数字扩展


## 对象扩展

## 数组扩展:
1. flat()
    - 数组的成员有时还是数组，Array.prototype.flat()用于将嵌套的数组“拉平”，变成一维的数组。该方法返回一个新数组,默认为1层拉平
    - 例:
        ```javascript
        [1, 2, [3, 4]].flat() // [1, 2, 3, 4]
        [1, 2, [3, [4, 5]]].flat() // [1, 2, 3, [4, 5]]
        ```
2. flatMap()
    - 对原数组的每个成员执行一个函数（相当于执行Array.prototype.map()），然后对返回值组成的数组执行flat()方法。该方法返回一个新数组，不改变原数组
    - 注意: flatMap()只能展开一层数组
    - 例:
        ```javascript
        [2, 3, 4].flatMap((x) => [x, x * 2]) // [2, 4, 3, 6, 4, 8]
        ```
## Set和Map
1. Set
    1. 注意:
        1. 成员的值都是唯一的，没有重复的值
        2. Set 函数可以接受一个数组（或者具有 iterable 接口的其他数据结构）作为参数，用来初始化
    2. 案例:
        ```javascript
        const s = new Set();
        [2, 3, 5, 4, 5, 2, 2].forEach(x => s.add(x));
        ```
    3. WeakSet
        - 注: 成员只能是对象
2. Map
    1. 本质: 键值对的集合
    2. 案例:
        ```javascript
        const items = [
            ['name', '张三'],
            ['title', 'Author']
        ];
        const map = new Map();
        items.forEach(
            ([key, value]) => map.set(key, value)
        );
        ```
    3. 转换:
            Map转数组:(使用扩展运算符...)
                const myMap = new Map()
                  .set(true, 7)
                  .set({foo: 3}, ['abc']);
                [...myMap]
    4. 数组转Map:
                new Map([
                  [true, 7],
                  [{foo: 3}, ['abc']]
                ])
    5. Map 转为对象:
                function strMapToObj(strMap) {
                  let obj = Object.create(null);
                  for (let [k,v] of strMap) {
                    obj[k] = v;
                  }
                  return obj;
                }

                const myMap = new Map()
                  .set('yes', true)
                  .set('no', false);
                strMapToObj(myMap)
    6. 对象转为 Map:
                function objToStrMap(obj) {
                  let strMap = new Map();
                  for (let k of Object.keys(obj)) {
                    strMap.set(k, obj[k]);
                  }
                  return strMap;
                }
                objToStrMap({yes: true, no: false})
    7. Map 转为 JSON:
                案例1: 键名都为字符串，先将Map转为Object对象，再将对象转为JSON
                    function strMapToJson(strMap) {
                      return JSON.stringify(strMapToObj(strMap));
                    }

                    let myMap = new Map().set('yes', true).set('no', false);
                    strMapToJson(myMap)
                案例2: 键名不为字符串
                    function mapToArrayJson(map) {
                      return JSON.stringify([...map]);
                    }
                    let myMap = new Map().set(true, 7).set({foo: 3}, ['abc']);
                    mapToArrayJson(myMap)
    8. JSON 转 Map
                案例1:
                    function jsonToStrMap(jsonStr) {
                      return objToStrMap(JSON.parse(jsonStr));
                    }
                    jsonToStrMap('{"yes": true, "no": false}')
                案例2:
                    function jsonToMap(jsonStr) {
                      return new Map(JSON.parse(jsonStr));
                    }
                    jsonToMap('[[true,7],[{"foo":3},["abc"]]]')
3. WeakMap:
    1. 作用: 用于生成键值对的集合
    2. 与Map的区别:
        1. WeakMap只接受对象作为键名（null除外），不接受其他类型的值作为键名
        2. WeakMap的键名所指向的对象，不计入垃圾回收机制

## Iterator


## Class
1. ES3、ES5生成构造方法
```javascript
    function Point(x, y) {
      this.x = x;
      this.y = y;
    }
    Point.prototype.toString = function () {
      return '(' + this.x + ', ' + this.y + ')';
    };
    var p = new Point(1, 2);
```
2. ES6:
    1. 使用:
        1. 类和模块的内部，默认就是严格模式，所以不需要使用use strict指定运行模式
        2. 可以通过实例的__proto__属性为“类”添加方
    2. 案例:
        1. 常规:
            1. 定义类:
                ```javascript
                class Point {
                    constructor(x, y) {
                        this.x = x;
                        this.y = y;
                    }

                    toString() {
                        return '(' + this.x + ', ' + this.y + ')';
                      }
                    }
                ```
        2. 表达式方式: Me只在 Class 的内部代码可用，指代当前类
            1. 创建类:
                ```javascript
                const MyClass = class Me {
                    getClassName() {
                        return Me.name;
                    }
                };
                ```
            2. 调用:
                ```javascript
                let inst = new MyClass();
                inst.getClassName() // Me
                ```
        3. 公有方法、私有方法
            ```javascript
            Class Student{
                publicfn : function(){
                }
                _privatefn : function(){
                }
            }
           ```
## Module
1. ES3、ES5
    1. 通过CommonJS模块S加载
    ```javascript
    let { stat, exists, readFile } = require('fs');

    // 等同于
    let _fs = require('fs');
    let stat = _fs.stat;
    let exists = _fs.exists;
    let readfile = _fs.readfile;
    ```
2. ES6
    1. 通过export命令显式指定输出的代码，再通过import命令输入
        - export
            1. 作用: export命令用于规定模块的对外接口
            2. 注意:
                1. export命令规定的是对外的接口，必须与模块内部的变量建立一一对应关系。
                2. 一个模块只能有一个默认输出，因此export default命令只能使用一次
            3. 案例:
                1. 输出变量:
                    ```javascript
                    // profile.js
                    export var firstName = 'Michael';
                    export var lastName = 'Jackson';
                    export var year = 1958;
                   ```
                2. 输出函数:
                    ```javascript
                    export function multiply(x, y) {
                      return x * y;
                    };
                    ```
                3. 输出类:
                    ```javascript
                    export {
                      v1 as streamV1,
                      v2 as streamV2,
                      v2 as streamLatestVersion
                    };
                    ```
                4. 默认模块输出:
                    ```javascript
                    export default function () {
                      console.log('foo');
                    }
                    //import命令可以为该匿名函数指定任意名字。
                    import customName from './export-default';
                    ```
                5. 默认变量输出(正确案例):
                    ```javascript
                    var a = 1;
                    export default a;
                    ```
                6. 默认变量输出(错误案例):
                    ```javascript
                    //export default命令的本质是将后面的值，赋给default变量，所以可以直接将一个值写在export default之后
                    export default var a = 1;
                    ```

        - import
            1. 作用: import命令用于输入其他模块提供的功能
            2. 注意:
                1. import命令是编译阶段执行的，在代码运行之前
                2. import后面的from指定模块文件的位置，可以是相对路径，也可以是绝对路径，.js后缀可以省略
                3. import是静态执行，所以不能使用表达式和变量
            3. 案例:
                1. 引入变量
                    ```javascript
                    import {firstName, lastName, year} from './profile.js';
                    function setName(element) {
                      element.textContent = firstName + ' ' + lastName;
                    }
                   ```
                2. 引入方法
                    ```javascript
                    import {multiply} from './profile.js';
                    multiply(1,2); // 2
                   ```
                3. 同时引入defualt 和其它变量、类、方法
                    ```javascript
                    import _, { each, each as forEach } from 'lodash';
                   ```

        - import函数:
            1. 作用: 运行时加载模块内容
            2. 注意:
                1. import()加载模块成功以后，这个模块会作为一个对象，当作then方法的参数
            3. 案例:
                1. 按需加载:
                    ```javascript
                    $element.addEventListener('click', event => {
                      import('./dialogBox.js')
                      .then(dialogBox => {
                        dialogBox.open();
                      })
                      .catch(error => {
                        /* Error handling */
                      })
                    }); 
                   ```
                2. 条件加载:
                    ```javascript
                    if (condition) {
                      import('moduleA').then(...);
                    } else {
                      import('moduleB').then(...);
                    }
                   ```
                3. 加载默认模块:
                    ```javascript
                    import('./myModule.js')
                    .then(myModule => {
                      console.log(myModule.default);
                    });
                   ```
                4. 加载多个模块:
                    ```javascript
                    Promise.all([
                      import('./module1.js'),
                      import('./module2.js'),
                      import('./module3.js'),
                    ])
                    .then(([module1, module2, module3]) => {
                       ···
                    });
                   ```
## Symbol
1. 产生: 通过Symbol函数生成
2. 作用: 防止属性名的冲突
3. 注意:
    1. Symbol函数前不能使用new命令,Symbol为原始类型
    2. Symbol 值不能与其他类型的值进行运算，会报错
4. ES6:
    1. 字符串:
    ```javascript
    let sym = Symbol('My symbol');
    String(sym) // 'Symbol(My symbol)'
    sym.toString() // 'Symbol(My symbol)'
    ```

## Promise
1. Promise 是异步编程的一种解决方案
2. 特点:
    1. 对象的状态不受外界影响。Promise对象代表一个异步操作，有三种状态：pending（进行中）、fulfilled（已成功）和rejected（已失败）
    2. 一旦状态改变，就不会再变，任何时候都可以得到这个结果。Promise对象的状态改变，只有两种可能：从pending变为fulfilled和从pending变为rejected
3. 案例:
    1. 基本使用:
    ```
    const promise = new Promise(function(resolve, reject) {
        // ... some code

        if (/* 异步操作成功 */){
            resolve(value);
        } else {
            reject(error);
        }
    });

    promise.then(function(value) {
         // success
    }, function(error) {
         // failure
    });
    ```
- 参考: git: https://github.com/cucygh/fe-material
- es6 阮一峰: http://es6.ruanyifeng.com/