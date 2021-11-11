## JSX语法
- 参考Blog: https://www.cnblogs.com/feng9exe/p/10906283.html
1. JSX是什么？
    JSX就是Javascript和XML结合的一种格式。React发明了JSX,利用HTML语法来创建虚拟DOM。从而利用操作虚拟DOM减少对实际DOM的操作从而提升性能。
2. JSX 案例
```
// 引入React，为编译JSX语法
import React from 'react';
import ReactDOM from 'react-dom';

// ReactDOM: React虚拟Dom  render 渲染
// <App /> JSX语法
// 使用自定义组件 JSX标签时，必须以大写字母开头。
// render 函数中，必须只包含一个整体元素，不能出现多个同级元素标签，React中 Fragment 标签可作为占位标签，不参与页面中DOM渲染。
ReactDOM.render(
  <div>Hello Word.</div>,
  document.getElementById('root')
);
```
3. 三元表达式
    - 大括号来加入JavaScript表达式
    ```
        ReactDOM.render(
          <div class={red ? 'redclass': 'whiteclass'}></div>,
          document.getElementById('root')
        );
    ```
4. 循环递归
    - 数组循环,数组的每个元素都返回一个React组件。

5. 事件绑定

6. html转义
    - React 默认会为HTML标签进行转义
    
