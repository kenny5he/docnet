# TypeScript 与 JavaScript的区别
## 基础语法
1. import
    1. Javascript 语法
   ```
   import React from 'react';
    ```
   2. TypeScript 语法
   ```
   import * as React from 'react';
    ```
## 类型定义
### 接口
```
interface Shape {
    // 作为变量使用的话用 const，若作为属性则使用readonly
    readonly sex: number;
    name: string;
    width: number;
    height: number;
    color?: string;
}

// 初始化对象
let shape:Shape = {
    sex: 1,
    name: '政',
    width: 100,
    height: 183
};

function area(shape : Shape) {
    var area = shape.width * shape.height;
    return "I'm " + shape.name + " with area " + area + " cm squared";
}
```
## 高阶用法
1. 类型属于对象
```typescript
const obj= {
    name: 'kenny',
    age: 18
}

function getByKey(key: keyof typeof obj) {
    const v = obj[key]
    return v;
}
```
2. 类型属于常量
```typescript
const colors = ['♠','♥','♣','♦']
const values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'] as const;
/** values 为元祖 **/
type Values = (typeof values)[number];
```
### 类
1. 类定义
```typescript
class Shape {
    area: number;
    color: string;
    constructor ( name: string, width: number, height: number ) {
        this.area = width * height;
        this.color = "pink";
    };
 
    shoutout() {
        // name 为局部变量， this.name: this存在 但无name属性，故为undefined
        return "I'm " + this.color + " " + this.name +  " with an area of " + this.area + " cm squared.";
    }
}

var square = new Shape("square", 30, 30);
console.log( square.shoutout() );
console.log( 'Area of Shape: ' + square.area );
```
2. 类继承
```typescript
class Shape3D extends Shape {
   volume: number;

   constructor ( public name: string, width: number, height: number, length: number ) {
      super( name, width, height );
      this.volume = length * this.area;
   };
   
   shoutout() {
      return "I'm " + this.name +  " with a volume of " + this.volume + " cm cube.";
   }

   superShout() {
      return super.shoutout();
   }
}
```
### 枚举
```typescript
enum Direction {
    // 不赋值，数字枚举，Up从0开始递增
    // 数字枚举，Up为1，Down为2，Left为3...
    // 注意: 数字枚举可以被混入到 计算过的和常量成员, 就像 Up = getUpValue(),
   
    // 赋值为字符串，字符串枚举
    Up = 1,
    Down,
    Left,
    Right
}
```

## 类型批注
### 常用类型批注
```
function area(shape: string, width: number, height: number) {
    var area = width * height;
    return "I'm a " + shape + " with an area of " + area + " cm squared.";
}
```




