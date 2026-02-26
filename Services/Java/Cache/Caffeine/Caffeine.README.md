## Caffeine
### UnboundedLocalCache 无界缓存

### BoundedLocalCache 有限缓存
1. 构建有限缓存
```
Caffeine.newBuilder()
    // 缓存中存储的最大缓存条目，当添加缓存时达到条目阈值后，将进行缓存淘汰操作
    .maximumSize(100)
    // 缓存访问后，一定时间失效
    .expireAfterAccess(100L, TimeUnit.SECONDS)
    // 缓存写入后，一定时间失效；以写入缓存操作为准计时
    // .expireAfterWrite()
    // 自定义缓存策略，满足多样化的过期时间要求。
    // .expireAfter()
    .build();
```
2. 缓存淘汰算法
> Caffeine淘汰算法：使用基于W-TinyLFU算法

1. FIFO：实现简单，类似于队列，先进先出，因此缓存命中率不是很高。
2. LRU：最近最久未使用算法（Least Recently Used）如果一个数据在一段时间内没有被访问，那么我们认为后面被访问的概率也很小。当我们添加新数据的时候，会把新数据放到队尾（假设新数据最大概率被再次访问），当我们长度到达阈值需要淘汰数据的时候，会从队首进行淘汰。这种算法造成缓存污染的概率会大些，比如现在有一些较少数据突增流量，但是后面不在访问，那么此时已经将热数据淘汰出去了，而缓存的数据后面也几乎不被访问。
3. LFU：最近最少使用算法（Least Frequently Used）如果一个数据在一段时间内访问的频率很小，那么认为后面被访问的几率也很小，所以淘汰访问频率最少的数据；该算法可以处理LRU因为冷数据突增带来的缓存污染问题。存在的问题是数据访问模式如果改变，这种算法命中率会下降，并且需要额外的空间存储信息频率。
4. W-TinyLFU：记录了近期访问记录的频率信息，不满足的记录不会进入到缓存。使用Count-Min Sketch算法记录访问记录的频率信息。依靠衰减操作，来尽可能的支持数据访问模式的变化。

- 参考: [入门] https://blog.csdn.net/l_dongyang/article/details/108326755
- 参考: [源码] https://blog.csdn.net/l_dongyang/article/details/123294062
- 参考: [算法] https://blog.csdn.net/l_dongyang/article/details/123461686