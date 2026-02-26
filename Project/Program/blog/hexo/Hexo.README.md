# Hexo

## Hexo项目
1. 初始化博客项目
```shell
# Advanced/Additional Higher Mathematics(高等数学)
npx hexo init ahm
```
2. 主题
    1. 安装主题
    ```shell
    # 移动到主题目录
    cd themes
    
    # 安装主题
    git clone -b master https://gitee.com/kennyhe/hexo-theme-next.git next
   
    # 安装 pug 以及 stylus 的渲染器
    npm i hexo-renderer-pug hexo-renderer-stylus
    ```
    2. 设置主题
        1. 文件 _config.yml 中 theme 设置为 hexo
        ```yml
        theme: hexo
        ```
        2. copy 
3. 安装插件
    1. mathjax 数学插件
        1. 安装 mathjax
        ```shell
        npm i hexo-math --save
        # 或 (推荐 renderer-mathjax)
        npm install hexo-renderer-mathjax --save
        ```
        2. 配置 mathjax
        ```yml
        
        ```