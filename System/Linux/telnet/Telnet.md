### Telnet
- 示例
```shell script
telnet 218.75.158.153 3128
# 出现Escape character is '^]'.后，按Ctrl+] 即可输入命令
```
- close关闭当前连接
- logout强制退出远程用户并关闭连接
- display显示当前操作的参数
- mode试图进入命令行方式或字符方式
- open连接到某一站点
- quit退出
- telnetsend发送特殊字符
- set设置当前操作的参数
- unset复位当前操作参数
- status打印状态信息
- toggle对操作参数进行开关转换
- slc改变特殊字符的状态
- auth打开/关闭确认功能z挂起
- telnetenviron更改环境变量?显示帮助信息