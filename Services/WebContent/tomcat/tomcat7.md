## Tomcat 7 
### 环境搭建
0. git clone https://github.com/apache/tomcat.git
1. 修改build.properties.default中的base.path值，主要作用是避免每次都从远程仓库下载jar包，base.path将指定这些jar存放的位置。
2. 在源码目录下使用命令行执行'ant ide-eclipse'进行编译
### 启动流程
- 启动类: 
