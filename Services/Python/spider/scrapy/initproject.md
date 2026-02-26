# 安装scrapy
```
pip3 install scrapy
```
# 使用scrapy建立项目
```
scrapy startproject CookCrawler
```
# 进入到项目目录
```
cd CookCrawler
```
#自动生成 爬虫模块
```
scrapy genspider meishichina www.meishichina.com
```

# windows下需要安装pypiwin32
```
pip3 install pypiwin32
```

# 调试url解析网站
```
scrapy shell www.meishichina.com
scrapy shell sz.ziroom.com/z/vr/61512929.html
```

