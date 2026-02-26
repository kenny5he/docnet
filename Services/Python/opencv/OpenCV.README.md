### Mac安装 OpenCV模块
#### 准备Python3环境，且通过pip3安装python依赖
- 准备python3环境

- 安装pip

- 安装numpy
```shell script
pip3 install numpy
```
- 安装scipy
```shell script
pip3 install scipy
```
#### 准备Homebrew环境，并更换中国科技大学或清华大学源

#### 安装 pkg-config，并配置环境变量
- 安装pkg-config
```shell script
brew install pkg-config
```
- 配置环境变量(~/.bash_profile)
```shell script
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib
```
#### 安装OpenCV并配置环境变量
##### Homebrew安装OpenCV 和 OpenCV contrib
- 安装opencv
```shell script
brew install opencv --with-python3 --c++11 --with-contrib
brew link --force opencv
```
- 默认安装路径在/usr/local/Cellar/opencv
- 配置环境变量(~/.bash_profile)
```shell script
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/Cellar/opencv/4.2.0_1/lib/pkgconfig
export LD_LIBRARY_PATH=/usr/local/Cellar/opencv/4.2.0_1/bin:$LD_LIBRARY_PATH
export PATH=${PATH}:/usr/local/Cellar/opencv/4.2.0_1/lib
```
- 验证安装opencv
```shell script
pkg-config --libs opencv4
pkg-config --cflags opencv4
```
##### 源码安装OpenCV 和 OpenCV Contrib
- 安装OpenCV(https://www.jianshu.com/p/162f2cdf4f88)
    - 下载Source源码(https://opencv.org/releases/)
    - 下载OpenCV Contrib源码
    ```shell script
      git clone https://github.com/opencv/opencv_contrib.git
    ```
    - 安装
    ```shell script
      cd <opencv_build_directory>
      cmake -DOPENCV_EXTRA_MODULES_PATH=<opencv_contrib>/modules <opencv_source_directory>
      make -j5
    ```