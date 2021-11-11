搭建Nexus
tar -xvf nexus

1.修改IP、端口、访问根目录，文件目录：etc/nexus-default.properties  heyekun54
2../nexus run 前端启动     ./nexus start 后端启动    ./nexus stop 关闭
3.忘记nexus密码 vi data/db/security/user.pcl   admin123
$NE+wqQq/TmjZMvfI7ENh/g==$V4yPw8T64UQ6GfJfxYq2hLsVrBY8D1v+bktfOxGdt4b/9BthpWPNUy/CBk6V9iA0nHpzYzJFWO8v/tZFtES8CA==

hosted，本地仓库，通常我们会部署自己的构件到这一类型的仓库。比如公司的第二方库。
proxy，代理仓库，它们被用来代理远程的公共仓库，如maven中央仓库。
group，仓库组，用来合并多个hosted/proxy仓库，当你的项目希望在多个repository使用资源时就不需要多次引用了，只需要引用一个group即可。

maven scope(compile/test/runntime/provided/system) 默认是compile
    compile  缺省值，适用于所有阶段，会随着项目一起发布
    test     测试阶段引入
    runntime 运行阶段
    provided 不将jar包打入至应用包中
    system   类似provided，需要显式提供包含依赖的jar，Maven不会在Repository中查找它(一定需要配合systemPath属性使用)
    
eclpse配置与JDK关联：-Dmaven.multiModuleProjectDirectory=$M2_HOME


https://issues.sonatype.org/
microfoolish/ApacheKenny.54
