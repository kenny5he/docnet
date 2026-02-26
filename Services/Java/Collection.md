# 集合算法

## 集合操作
```
// 当存在集合A / B
A: {1,2,3,3,4,5}
B: {3,4,4,5,6,7}
```
1. 取集合并集
   ```
    CollectionUtils.union(a, b)
    // 输出结果为: {1,2,3,3,4,4,5,6,7}
   ```
2. 取集合交集
   ```
    CollectionUtils.intersection(a, b)
    // 输出结果为: {3,4,5}
   ```
3. 取集合交集的补集
   ```
    CollectionUtils.disjunction(a, b)
    // 输出结果为: {1,2,3,4,6,7}
   ```
4. 取集合差集
   1. A与B的差集
   ```
    CollectionUtils.subtract(a, b)
    // 输出结果为: {1,2,3}
   ```
   2. B与A的差集
   ```
    CollectionUtils.subtract(b, a)
    // 输出结果为: {4,6,7}
   ```