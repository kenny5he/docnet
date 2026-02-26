# OpenResty

### OpenResty Edge


## OpenResty 应用
### Gray Deploy (灰度发布)
- 解释: 应用部署测试完成后，完全将全部流量切换到新部署的应用服务器上
1. 方案1: 判断请求头 req-env: gray
    1. lua 脚本:
    ```lua
    
    ```

- 方案: https://zhuanlan.zhihu.com/p/501286088
### Blue Deploy (蓝绿发布)
- 解释: 应用部署测试完成后，将部分用户(例: 20%)切换至部署后的应用服务器上，并监测新切换到应用的(例:20%)用户服务接口、内存CPU负载、日志错误信息及运营手段 判断是否存在功能BUG。待无Bug后，将全部流量切换至新部署的应用。

###
- Github: https://github.com/openresty/openresty
- Docs: https://doc.openresty.com.cn/cn/
- Github: https://github.com/moonbingbing/openresty-best-practices