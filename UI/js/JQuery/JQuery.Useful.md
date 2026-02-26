1. callback
```javascript 1.8
function a(callback) {
    if (typeof callback === "function"){
        callback(); 
    }
}

function b(){ 
    console.info("我是回调函数b");
}

// 调用回调函数
a(b);
```
2. apply 与 call
    1. 使用方式
        - apply()方法
            ```javascript
            function.apply(thisObj[, argArray])
            ```
        - call()方法
            ```javascript
            function.call(thisObj[, arg1[, arg2[, [,...argN]]]]);
            ```
    2. 定义：
        - apply：应用某一对象的一个方法，用另一个对象替换当前对象。例如：B.apply(A, arguments);即A对象应用B对象的方法。
        - call：调用一个对象的一个方法，以另一个对象替换当前对象。例如：B.call(A, args1,args2);即A对象调用B对象的方法。
    3. 共同之处：
        - 都“可以用来代替另一个对象调用一个方法，将一个函数的对象上下文从初始的上下文改变为由thisObj指定的新对象”。
    4. 不同之处：
        - apply：最多只能有两个参数——新this对象和一个数组argArray。如果给该方法传递多个参数，则把参数都写进这个数组里面，当然，即使只有一个参数，也要写进数组里。如果argArray不是一个有效的数组或arguments对象，那么将导致一个TypeError。如果没有提供argArray和thisObj任何一个参数，那么Global对象将被用作thisObj，并且无法被传递任何参数。
        - call：它可以接受多个参数，第一个参数与apply一样，后面则是一串参数列表。这个方法主要用在js对象各方法相互调用的时候，使当前this实例指针保持一致，或者在特殊情况下需要改变this指针。如果没有提供thisObj参数，那么 Global 对象被用作thisObj。 

3. 如何实现JS的继承(blog: https://www.cnblogs.com/humin/p/4556820.html)
    - 原型链继承:
        ```javascript
        function Parent(){}
        function Child(){}
        Child.prototype = new Parent();
        ```
    - 构造继承:
        ```javascript
        function Parent(){}
        function Child(){ Parent.call(this); }
        ```
    - 实例继承:
        ```javascript
        function Parent(){}
        function Child(){ var instance = new Parent(); }
        ```
    - 拷贝继承:

    - 组合继承:

4. 什么是闭包？闭包的应用场景(blog:https://www.cnblogs.com/star-studio/archive/2011/06/22/2086493.html)
	1. 什么是闭包？
	    ```javascript
            function a(){
                var i = 0;
                function b(){
                    return i++;
                }
                return b;
            }
            var c = a();
            c();
        ```
		- 当函数a的内部函数b被函数a外的一个变量引用的时候，就创建了一个闭包。
	2. 应用场景:
        1. 使用闭包代替全局变量
            ```javascript
            (function() {
                // JS
            })();
            ```
        2. 函数外或在其他函数中访问某一函数内部的参数
            ```javascript
            (function() {
            })();
            ```
        3. 在函数执行之前为要执行的函数提供具体参数
            ```javascript
            ```
        4. 在函数执行之前为函数提供只有在函数执行或引用时才能知道的具体参数
            ```javascript
            ``` 
        5. 为节点循环绑定click事件，在事件函数中使用当次循环的值或节点，而不是最后一次循环的值或节点
            ```javascript
            ```
        6. 暂停执行
            ```javascript
            ```
        7. 包装相关功能
            ```javascript
            let counter = (function() {
                let privateCounter = 0;
                function changeBy(val) {
                    privateCounter += val;
                }
                return {
                    increment: function() {
                        changeBy(1);
                    },
                    decrement: function() {
                        changeBy(-1);
                    },
                    value: function() {
                        return privateCounter;
                    }
                }
            })();

            // 使用
            console.log(counter.value()); // 0
            counter.increment();
            console.log(counter.value()); // 1
            counter.decrement();
            console.log(counter.value()); // 0
            ```
5. 延时器
```javascript
// 定义延时器
var defer = $.Defrred();
// 结束延时
defer.resolve();
defer.done(function(){
    // 延时后做某事
});
```