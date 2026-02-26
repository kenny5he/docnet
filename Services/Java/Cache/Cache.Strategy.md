# 缓存策略
## FIFO(先入先出)
1. 参考实现类: org.apache.ibatis.cache.decorators.FifoCache
2. 核心思想: 通过维护一个固定容量的队列，队列的规则就是先入先出，插入值的时候判断是否达到设定缓存最大值，如果符合条件则移除队列中第一个值。

## LRU(最近最少使用)
1. 参考实现类: 
    1. org.apache.ibatis.cache.decorators.LruCache
    2. org.apache.dubbo.cache.util.LruCache
2. 核心思想:
    1. 维护一个 LinkedHashMap，固定大小为缓存容量最大值。
    2. 重写LinkedHashMap的removeEldestEntry方法，判断其大小是否超过我们设定的最大值，大于则移除Map中的Entry值
    3. 注意: 默认创建LinkedHashMap并不会开启LRU策略，由accessOrder值控制，在put/get 值时是否按最近使用策略将值移动至 tail位。
        ```java
        LinkedHashMap linkedHashMap = new LinkedHashMap(16,0.75f,true);
        ```
3. LinkedHashMap 中removeEldestEntry的核心思想
    1. eldestKey 计算策略?

## LFU(最少使用(次数))
1. LFU算法是根据一段时间内数据项被使用的次数选择出最少使用的数据项
2. LFU与LRU的区别: LFU 根据使用次数的差异决定，而LRU是根据最近使用时间差异决定
3. LFU的核心实现思想: 

### W-TinyLFU
1. 参考实现类:

2. 核心思想:
    1. 记录了近期访问记录的频率信息，不满足的记录不会进入到缓存。使用Count-Min Sketch算法记录访问记录的频率信息。依靠衰减操作，来尽可能的支持数据访问模式的变化。

15:00

5栋4楼
0403会议室