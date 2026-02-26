# yield
1. 语法
```javascript
[rv] = yield [expression];
```
  - expression 定义通过迭代器协议从生成器函数返回的值。如果省略，则返回undefined。
  - rv 返回传递给生成器的next()的可选值，以恢复其执行。
## yield 关键字

## yield 表达式

## 作用

## 常见使用场景

## 开源官方使用
1. axios
   1. axios/helper/readBlob
      1. yield*
      ```javascript
        yield* blob.stream()
        ```
        - 作用:
      2. yield
      ```javascript
        yield await blob.arrayBuffer()
        ```
        - 作用: 