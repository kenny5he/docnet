## 企业微信联调
### 登录功能
#### 扫码授权登录功能
1. 接口: https://open.work.weixin.qq.com/wwopen/sso/qrConnect?appid=CORPID&agentid=AGENTID&redirect_uri=REDIRECT_URI&state=STATE
    - corpid: ww5f87fc7b462fb06d
    - agentId:
    - redirect_uri:
    - state: 随机生成，防止csrf
2. 页面引入JS: http://wwcdn.weixin.qq.com/node/wework/wwopen/js/wwLogin-1.2.5.js
3. JS 代码:
    ```javascript
    var wwLogin = new WwLogin({
		"id": "wx_reg",  
		"appid": "",
		"agentid": "",
		"redirect_uri": "",
		"state": "",
		"href": "",
		"lang": "zh",
    });
    ```

- 企业微信官方文档: https://developer.work.weixin.qq.com/document/path/90665#corpid

