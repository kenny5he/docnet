# Maven Settings
1. settings.xml文件一般存在于两个位置：
  - 全局配置: ${M2_HOME}/conf/settings.xml
  - 用户配置:  𝑢𝑠𝑒𝑟.ℎ𝑜𝑚𝑒/.𝑚2/𝑠𝑒𝑡𝑡𝑖𝑛𝑔𝑠.𝑥𝑚𝑙𝑛𝑜𝑡𝑒：
2. 配置优先级从高到低：pom.xml> user settings > global settings

# 标签
1. LocalRepository
```xml
    <!-- 系统本地仓库的路径-->
    <localRepository>${user.home}/.m2/repository</localRepository>
```
2. Servers
```xml
    <!-- 仓库访问安全认证 -->
    <servers>
        <server>
            <!-- id与distributionManagement中repository元素的id相匹配 -->
            <id>alpha-fashion-public</id>
            <username>alpha</username>
            <password>74123</password>
        </server>
    </servers>
```
3. Mirrors
```xml
    <mirrors>
        <!-- Aliyun Maven Public -->
        <mirror>
            <id>aliyun-public</id>
            <mirrorOf>*</mirrorOf>
            <name>aliyun public</name>
            <url>https://maven.aliyun.com/repository/public</url>
        </mirror>
    
        <!-- 给定仓库的下载镜像。 -->
        <mirror>
            <!--  -->
            <id>alpha-fashion-public</id>
            <name>Alpha Fashion Public</name>
            <!-- 该镜像的URL。构建系统会优先考虑使用该URL，而非使用默认的服务器URL -->
            <url>http://192.168.1.30:8081/repository/maven-public/</url>
            <!-- 被镜像的服务器的id。例如，如果我们要设置了一个Maven中央仓库（http://repo.maven.apache.org/maven2/）的镜像，就需要将该元素设置成central。这必须和中央仓库的id central完全一致。 -->
            <mirrorOf>central</mirrorOf>
        </mirror>
    </mirrors>
```
4. Repositories
```xml
<repositories>
    <!--包含需要连接到远程仓库的信息 -->
    <repository>
        <!--远程仓库唯一标识 -->
        <id>codehausSnapshots</id>
        <!--远程仓库名称 -->
        <name>Codehaus Snapshots</name>
        <!--如何处理远程仓库里发布版本的下载 -->
        <releases>
            <!--true或者false表示该仓库是否为下载某种类型构件（发布版，快照版）开启。 -->
            <enabled>false</enabled>
            <!--该元素指定更新发生的频率。Maven会比较本地POM和远程POM的时间戳。这里的选项是：always（一直），daily（默认，每日），interval：X（这里X是以分钟为单位的时间间隔），或者never（从不）。 -->
            <updatePolicy>always</updatePolicy>
            <!--当Maven验证构件校验文件失败时该怎么做-ignore（忽略），fail（失败），或者warn（警告）。 -->
            <checksumPolicy>warn</checksumPolicy>
        </releases>
        <!--如何处理远程仓库里快照版本的下载。有了releases和snapshots这两组配置，POM就可以在每个单独的仓库中，为每种类型的构件采取不同的策略。例如，可能有人会决定只为开发目的开启对快照版本下载的支持。参见repositories/repository/releases元素 -->
        <snapshots>
            <enabled />
            <updatePolicy />
            <checksumPolicy />
        </snapshots>
        <!--远程仓库URL，按protocol://hostname/path形式 -->
        <url>http://snapshots.maven.codehaus.org/maven2</url>
        <!--用于定位和排序构件的仓库布局类型-可以是default（默认）或者legacy（遗留）。Maven 2为其仓库提供了一个默认的布局；然而，Maven 1.x有一种不同的布局。我们可以使用该元素指定布局是default（默认）还是legacy（遗留）。 -->
        <layout>default</layout>
    </repository>
</repositories>
```