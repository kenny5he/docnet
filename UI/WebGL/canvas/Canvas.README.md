# Canvas 

## Canvas 案例
1. 创建画布
```html
<canvas id="demo-canvas" height="300" width="960"></canvas>
```
2. 获取画布
```javascript
var canvasEle = document.getElementById("demo-canvas");
const ctx = canvasEle.getContext("2d");
```
3. 绘制矩形
```javascript
/**
 * 绘制矩形
 * param1: x 距离 [0,0] 的位置
 * param2: y 距离 [0,0] 的位置
 * param3: 宽度
 * param4: 高度
 */
ctx.fillRect(10,10,100,50)
// 绘制颜色
ctx.fillStyle = "blue"
/**
 * 绘制描边矩形
 * param1: x 距离 [0,0] 的位置
 * param2: y 距离 [0,0] 的位置
 * param3: 宽度
 * param4: 高度
 */
ctx.strokeRect(10,10,100,50)
```
4. 路径绘制
```javascript
// 路径绘制起点
ctx.beginPath()
// 画笔起始位置
ctx.moveTo(x,y)
// 行绘制路径
ctx.lineTo(10,20)
// 路径绘制终点
ctx.closePath()
// 填充内容 (闭合区域) (单个线段不可填充，需要多个线构成一个区域，才能填充)
ctx.fill()
// 描边区域 (可以构建单线段显示)
ctx.stroke()
```
5. 绘制圆
```javascript
// 路径绘制起点
ctx.beginPath()
/**
 * 绘制圆弧 （不用从 moveTo开始）
 * param 1: x
 * param 2: y 
 * param 3: r 半径
 * param 4: 起始角
 * param 5: 结束角
 * param 6: 绘制方向 (默认为 ), true:  false:
 */
ctx.arc(100, 100, 30, 0, Math.PI * 2, false)
// 
ctx.stroke()
```
6. 绘制异形图
```javascript

// 路径绘制起点
ctx.beginPath()
/**
 * 二次贝赛尔曲线
 */
ctx.quadraticCurveTo()

/**
 *  三次贝赛尔曲线
 */
ctx.bezierCurveTo()

// 描边
ctx.stroke()
```