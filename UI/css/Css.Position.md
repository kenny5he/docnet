# Css 定位
## Flexbox (盒子模型)


## Position
### static (静态定位)

### relative (相对定位)

### absolute (绝对定位)

### fixed (固定定位)

### sticky (粘性定位)

## display
### flex (启用弹性布局)
- 资料参考: https://css-tricks.com/snippets/css/a-guide-to-flexbox/
flex 通过主轴 Main Axis（水平方向）、交叉轴 Cross Axis(垂直方向)
1. Flex 作用域：直接关联的子属性
#### Flex 作用属性
1. flex-direction:
    1. 用于设置 弹性容器方向，默认值: row (水平方向) 
    2. 值设置:
        - 水平方向:
            1. row: 从左到右
            2. row-reverse: 从右到左
        - 垂直方向:
            1. column: 从上到下
            2. column-reverse: 从下到上
2. justify-content:
    1. 用于设置 主轴子元素排列方式 (水平方向)
    2. 值选项
        1. flex-start: 水平方向，主轴起点排列
        2. flex-end: 水平方向，主轴终点排列
        3. center: 水平方向，主轴中心
        4. space-between: 第一个、最后一个贴着元素边缘，根据容器大小，元素之间填充间距。
        5. space-evenly: 元素间填充间距大小相同 (包括第一个、最后一个元素 到边缘的间距空间) (效果: 间距均匀)
        6. space-around: 单个元素左右间距相同，(效果：距边框的元素间距视觉效果小，两两元素相隔视觉效果间距大(左右间距相加))
3. align-content: (垂直方向多行)
    ![align-content](assets/imgs/align-content.svg)
    1. 以水平为主轴，内容从上到下排列
    2. 值选项:
        1. flex-start: 
        2. flex-end:
        3. center:
        4. stretch: 
        5. space-between:
        6. space-around:
4. align-items: (垂直方向单行)
   ![align-items](assets/imgs/align-items.svg)
    1. 用于设置 交叉轴子元素的排列方式 (垂直方向)
    2. 值选项: 
       1. flex-start: 垂直方向，顶部排列
       2. flex-end: 垂直方向，底部排列
       3. center: 垂直方向，中心排列
       4. stretch: 垂直方向，高度不足，拉长填充满
       5. baseline: 
    
5. flex-wrap:
    1. 设置元素换行，(默认情况下，所有 flex 元素都会尝试放在一行)
    2. 值设置:
        1. nowrap: 不换行 
        2. wrap: 从上到下换到多行
        3. wrap-reverse: 从下到上换到多行

6. flex-flow: 
    1. flex-direction 加 flex-wrap 的效果，默认值: flex-flow: row nowrap;
7. gap/row-gap/column-gap: 
    1. 设置列间隙，类似于给子元素设置 margin
### content
当子元素被包含在父元素内，content 可视父元素不存在，子元素直接作用于爷元素。
1. 使用注意：
    1. 父元素边距、内边距 失效