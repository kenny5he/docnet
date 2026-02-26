### Mock 模拟数据 
#### Mockjs
1. 安装Mockjs
```
npm install mockjs
```
2. 使用mockjs
```
import Mock from 'mockjs'
Mock.mock('','get')
```


### Koa Proxy 请求
1. 安装 koa、koa-router、koa-cors
```
npm install koa koa-router koa-cors
```
2. 创建mock.server.js
```
let Koa = require('koa')
let Router = require('koa-router')
let cors = require('koa-cors')
let fs = require('fs')

const app = new Koa()
const router = new Router()

router.get('/services/api/home/index',async ctx=> {
    // 允许 cors 跨域请求
    await cors()
    // 数据
    ctx.body = JSON.parse(fs.readFileSync('./test/mock/home.json'))
})

app.use(router.routes()).use(router.allowedMethods())

app.listen(3000,()=>{

})
```
3. 配置Webpack
```
module.exports = {
  devServer: {
    port: 8080,
    https: false,
    // 自动启动浏览器
    open: true,
    proxy: {
        "/services/api": {
            target: "http://127.0.0.1:3000",
            changeOrigin: true
        }
    }
  }
}
```
