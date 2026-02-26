###调试HotSpot
[思维导图](https://www.processon.com/view/5aeda8d8e4b0958cdad337f3)
#### 环境说明
- 版本要求: [jdk8u60](hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/READEME-builds.html)、[jdk9](http://hg.openjdk.java.net/jdk9/jdk9/file/a08cbfc0e4ec/common/doc/building.html)
- 系统版本: MacOS Mojave 10.14.6
- 软件版本: XCode
#### 准备工作
1. 获取JDK源码:
    ```shell script
    hg clone http://hg.openjdk.java.net/jdk8u/jdk8u60(对系统有要求Mac 10.14)
    ```
2. 运行脚本:
    ```shell script
    sh get_source.sh
    ```
    - 问题:
        1. 报错信息: WARNING: jdk exited abnormally (255)
        2. 问题原因: 网络问题造成多次运行脚本即可

#### 源码编译
0. 软件环境
    1. 安装HomeBrew
        ```shell script
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        ```
    2. 安装软件依赖
        ```shell script
         brew install mercurial
         brew install ccache
         brew install freetype
         ```
1. 加执行权限
   chmod +x configure
2. 编译源码
    1. 编译前配置
       <br/>注意: freetype路径根据安装版本而定
        ```shell script
        ./configure --with-target-bits=64 --with-freetype=/usr/local/Cellar/freetype/2.10.1/ --enable-ccache --with-jvm-variants=server,client --with-boot-jdk-jvmargs="-Xlint:deprecation -Xlint:unchecked" --disable-zip-debug-info --disable-warnings-as-errors --with-debug-level=slowdebug 2>&1 | tee configure_mac_x64.log
        ```
        - 问题
            1. 报错信息
                ```
               configure: error: No xcodebuild tool and no system framework headers found, use --with-sysroot or --with-sdk-name to provide a path to a valid SDK
                /Users/apaye/workspace/hg/jdk9/common/autoconf/generated-configure.sh: line 82: 5: Bad file descriptor
               ```
            2. 解决方案
                ```
                sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
                ```
    2. 编译
        ```shell script
        export LANG=C
        make all LOG=debug  2>&1 | tee make_mac_x64.log
        ```
        - 问题
            1.

#### 导入工程
##### 导入Xcode
##### 导入CLion

#### 调试启动      