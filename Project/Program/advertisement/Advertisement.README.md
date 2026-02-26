# Advertisement 广告推送系统

## 广告相关概念
### SSP () 供应方平台

### DSP () 需求方平台
一种服务器，可基于包括当前广告活动和观看者偏好在内的标准提供广告插播规范。

### ADS () 广告决策服务器

### ADX (Ad Exchange) 广告交易平台
ADX是AD Exchange的缩写，即广告交易市场，是为DSP（需求方平台）和SSP（供给方平台）服务的，起到衔接、匹配的作用。它接收到SSP的请求后，将广告流量信息传递给DSP，询问它们的出价。DSP响应后返回相应的广告创意及出价。朴素地说，ADX是基于RTB（RealTime Bidding 实时竞价）进行的，媒体的广告放在上面，价高者得，更加公平公正。

1. 功能
    1. 流量控制：ADX能控制一次广告请求发送到哪些DSP
    2. 创意审核 ADX应该对DSP的广告创意进行审核，只有审核通过的广告创意才能在竞价中胜出。这个工作量一般比较大，也存在时效性的问题.对于信任的DSP，实践中一般采用后审，仅当广告创意被投诉时才会有运营人员介入，进行审核操作。
    3. 条件过滤 ADX可以设置一些广告过滤条件，对参与竞价的广告进行过滤，例如
        1. 底价过滤：DSP的出价必须要大于底价才能参与竞价；
        2. 敏感词过滤：创意的标题、文案等内容是否包含敏感词；这个过滤可以视为自动化的创意审核。

## 广告植入手段
### CSAI (Client Side Ad Insertiion) 客户端广告插入
### SSAI (Server Side Ad Insertion) 服务端广告插入
### OTT ()

## 广告系统相关协议
### OpenRTB(Real-Time Bidding) 实时竞价
RTB 最初旨在帮助发布商向广告商出售剩余库存，现在用于销售所有类型的库存，包括优质库存。
RTB 不是从同一发布商那里购买数千次展示，而是允许广告商跨多个发布商购买单独的展示，以更准确地接触目标受众，并根据特定时间有关网站和用户的已知信息进行出价。

### VAST (Vedio Ad Serving Template) 视频广告投放模板

### VMAP (Video Multiple Ad Playlist) 视频多广告播放列表

### VPAID (Video Player Ad Interface Definition) 视频播放广告接口定义 （已弃用）



### 流媒体传输协议 (M3U8+TS)
### 广告位插入协议 (SCTE-35)

- 参考文档: https://zhuanlan.zhihu.com/p/642335272
- Vast 3.0文档: https://www.jianshu.com/p/ea11a65f5043
- Amazon AWS Elemental MediaTailor: https://docs.aws.amazon.com/zh_cn/mediatailor/latest/ug/what-is-terms.html
- Google: https://developers.google.cn/authorized-buyers/rtb/adx-video-guide?hl=zh-cn
- IAB VPAID: https://iabtechlab.com/standards/video-player-ad-interface-definition-vpaid/
- IAB VMAP: https://iabtechlab.com/standards/video-multiple-ad-playlist-vmap/
- IAB VAST: https://iabtechlab.com/standards/vast/
- IAB OpenRTB: https://iabtechlab.com/standards/openrtb/
- 