# BigDecimal 
1. 金钱类 数值计算推荐使用 BigDecimal，不建议使用 Double/Integer/Float/Number等  

## 数值对比(相等、大于、小于)
1. a.compareTo(b)
   1. -1: a 小于 b
   2. 0: a等于b
   3. 1: a大于b

## 数值加、减、乘、除计算
### 加法计算(add)

### 减法计算(subtract)

### 乘法计算(multiply)

### 除法计算(divide)
1. divide(BigDecimal divisor,int scale,int roundingMode)


## 格式化小数点
1. setScale(number, BigDecimal )
    1. 第一个参数为保留 number 位小数，默认用四舍五入
    2. 第二个参数可选, BigDecimal.ROUND_DOWN: 直接删除多余的小数位
    3. 第二个参数可选, BigDecimal.ROUND_UP: 进位处理，例: 2.351 变为 2.36
    4. 第二个参数可选, BigDecimal.ROUND_HALF_UP: 四舍五入
    5. 第二个参数可选, BigDecimal.ROUND_HALF_DOWN: 四舍五入，例: 2.356 变为 2.35