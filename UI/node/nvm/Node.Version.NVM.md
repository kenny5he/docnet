## Node 版本管理
1. 安装n
```shell
npm install -g n
```
2. 查看n版本
```shell
n --version
```
3. 展示n管理的node所有版本
```shell
n list
```
4. 安装node版本
```shell
# 安装指定版本
sudo n install 16.19.1
# 安装最新版
sudo n latest
```
5. 切换版本
```shell
# 输入n，切换至指定版本
sudo n
```
6. 解决
    1. 错误信息
    ```
    node: --openssl-legacy-provider is not allowed in NODE_OPTIONS
    ```
    2. 解决方式
    ```
    unset NODE_OPTIONS
    ```
7. 设置nvm mirror
```shell
nvm npm_mirror https://repo.huaweicloud.com/repository/npm/
```
7. 设置版本npm配置
```
npm config set disturl https://repo.huaweicloud.com/nodejs
npm config set sass_binary_site https://repo.huaweicloud.com/node-sass
npm config set registry https://repo.huaweicloud.com/repository/npm/
npm config set phantomjs_cdnurl https://repo.huaweicloud.com/phantomjs
npm config set chromedriver_cdnurl https://repo.huaweicloud.com/chromedriver
npm config set operadriver_cdnurl https://repo.huaweicloud.com/operadriver
```
8. 设置npm文件夹
```shell
npm config set prefix "/Users/apaye/workspace/node/npm/node_global"
npm config set cache "/Users/apaye/workspace/node/npm/node_cache"
```