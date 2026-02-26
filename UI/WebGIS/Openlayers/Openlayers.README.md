# Openlayers 
- 主流的地图2D 开发框架 
- https://openlayers.org

## 注意点
- 多数地图框架不使用经纬度作为默认坐标体系，使用墨卡托坐标体系，需使用 fromLonLat(x,y) 进行转换
- 设置 View 中的 projection 值调整默认坐标体系，墨卡托坐标体系("EPSG:3857")、经纬度坐标体系("EPSG:4326")

## 参考
- 学习视频地址: https://www.bilibili.com/video/BV1it1jYZEbj