## Less Feature
### 导入
```less
@import "library"; // 导入 library.less
```

### Compute (计算)
1. 加减乘除
```less
div {
  width: 100px + 20;
}
```
2. 加减乘除 (计算机器函数 calc)
```less
div {
 width: calc(100% - 20px);
}
```

### Nest (嵌套)
1. 父子嵌套
   1. 代码
    ```less
    .box1 {
      width: 100px;
      .box2 {
        width: 70px;
      }
    }
    ```
   2. 编译
    ```css
    .box1 {
      width: 100px;
    }
    .box1 .box2 {
        width: 100px;
    }
    ```
2. 同级嵌套 (&)
    1. 代码
    ```less
    .box1 {
        width: 100px;
        &:hover {
            width: 70px;
            height: 70px;
        }
    }
    ```
    2. 编译
    ```css
    .box1 {
        width: 100px;
    }
    .box1:hover {
        width: 70px;
        height: 70px;
    }
    ```
3. 交集选择器
    1. 代码
    ```css
    .box2 {
        width: 100px;
        &.box3 { 
            width: 70px;
        }
    }
    ```
    2. 编译
    ```css
    .box2 {
        width: 100px;
    }
    .box2.box3 {
        width: 70px;
    }
    ```

### Variables (变量)
1. 变量 (@)
    1. 变量的命名规则与通用代码规则一致：①、大小写敏感；②、字母数字下划线，不能以数字开头；
    2. 变量的作用域：
       1. 全局变量整个文档都可以用；
       2. 局部变量只能在此集合及子级中中用，且优先级更高；
    3. 案例1
    ```less
    @wid: 80px;
    .box8 {
        width: @wid;
    }
    ```
2. 混合使用
    1. 案例1 
    ```less
    .w70 {
      width: 70px;
    }
    //调用.w70
    .box {
      .w70;
    }
    ```
    2. 案例2: 局部调用
    ```less
    .common{
        .button {
            border: 1px solid black;
            background-image: linear-gradient(pink,aqua);
            width: 200px;
            height: 200px;
        }
        .font {
            font-size: 25px;
            color: blue;
        }
    }
    //调用button模块的button部分
    .box {
        .common.button;
    }
    ```
    3. 调用混合参数某属性
    ```less
    .common{
        .button {
            border: 1px solid black;
            background-image: linear-gradient(pink,aqua);
            width: 200px;
            height: 200px;
        }
    }
    .b {
        width: .common.button[width];
    }
    ```
    4. 混合参数传参
    ```less
    .box(@wid, @hgh){
        width: @wid;
        height: @hgh;
        background-color: #fff;
        border: 1px solid blanchedalmond;
    }

    .box1 {
        .box(100px,200px)
    }
    ```
    5. 混合函数式
    ```less
    .common(@bg) {
        width: 300px;
        height: 200px;
        background-color: @bg;
        border: 1px solid black;
        border-radius: 5px;
    }
    .box {
        display: flex;
        justify-content: space-around;
        align-items: center;
        .box1 {
            .common(pink);
        }
        .box2 {
            .common(aqua);
        }
        .box3 {
            .common(rgb(72, 145, 204));
        }
    }
    ```
### Extends (继承)


- 参考: https://less.bootcss.com/features/