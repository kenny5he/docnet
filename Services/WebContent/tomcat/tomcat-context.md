### Host 配置
```xml
<Host name="localhost" appBase="" unpackWARs="true" autoDeploy="true">
    <context path="/icarenext" docBase="/User/apaye/workspace/git/luban/tomcat/">
        
    </context>

</Host>
```
- 注释: name代表域名，主要作用为进行多应用间隔离，appBase代表 ，unpackWARs代表解压War包，autoDeploy代表自动部署


### tomcat-context配置模板
```xml
<context path="/icarenext" docBase="/User/apaye/workspace/git/luban/tomcat/">
    
</context>
```
- 注释: path代表访问上下文根，docBase代表编译后的代码路径
