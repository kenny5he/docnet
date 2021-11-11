Shell
  定义：命令行解释器
  版本：cat /etc/shells
       /bin/sh        Bourne Shell
       /bin/bash      Bourne again Shell
       /sbin/nologin  非登录Shell
       /bin/tcsh      tc Shell
       /bin/csh       C Shell
       /bin/ksh       Korn Shell
  查看版本bash --version     
  安装调试脚本工具(bashdb)
  http://sourceforge.jp/projects/sfnet_bashdb (./configure make make install)
  调试
      bash -debug 脚本名
      debug命令列表
      命令                     功能
      1                     打印源代码
      -                     打印当前执行行往前10行的代码
      .                     打印当前执行行的代码
      w                     打印大会嗯前执行行前后各5行的代码
      /pattern/             往后查找匹配pattern的行
      ?pattern?             往前查找匹配pattern的行
      H                     退出历史命令
      quit                  打印历史命令
      info a                查看参数信息
      info b                查看段点信息
      info d                查看由display命令设置的列表
      info files            查看源文件信息
      info function         查看函数信息
      info l                查看当前行和文件名
      info p                查看当前调试状态
      info stack            查找栈信息
      info terminal         查看终端信息
      info v                查看所有变量信息
      hi n                  查看所有变量信息
      show                  显示设置信息
      set                   设置
      e                     当前环境中执行Shell命令
      disp                  设置Shell命令列表
      step n                前进n步，遇到函数进入
      next n                前进n步，遇到函数不进入
      回车                   重复上一个n或s命令
      continue              继续执行，可以接一个数字作为参数，执行到指定行
      break                 后接一个数字作为参数，可设置指定行为断点
      delete                后接一个段点号，用于删除指定断点
      D                     删除所有段点
      skip n                跳过下面的n条语句不执行
      clear                 清除指定行上的所有断点
      R                     重启当前调试脚本
      return                中断当前函数并返回
      print                 打印指定的变量值
      help                  打印帮助信息
  Shell基础命令使用    
      声明变量(declare/typeset)
        declare 弱类型声明变量(不区分类型)
          declare -r 声明只读变量
          declear -i 声明整型变量
          declear -a Arrary
        变量命名规则：
          不能一数字开头
          不能以特殊字符开头
          不能和Shell的预设变量名重名
          不能使用Shell关键字
      取消变量(unset)
      特殊变量($# 总参数个数  $@总参数详细值  脚本命令返回值 (正常 0 异常 127))
      使变量被子Shell识别(export)
      声明局部变量(local)
      从标准输入读取一行到变量(read)
      打印字符(echo)
        echo -e (允许打印转义字符)
      跳出循环(break)  
      循环控制(continue)
      执行命令Shell(exec)
      退出shell(exit)
      定义函数返回值(return)
      显示当前工作目录(pwd)
      注释(#)(#!不认为是注释)  
      向左移动位置参数(shift)
      显示并设置进程资源限度(ulimit)
         ulimit -a 查看当前系统的软限制
         ulimit -n 4096 设置最大打开文件数
         ulimit -S -n 4096 使用-S参数单独设置软限制
         ulimit -H -n 4096 使用-H参数单独设置硬限制
      << EOF  将我们输入的命令字符串作为一个执行程序的输入
      	用法案例1：mysql -u root -ppassword << EOF   
        用法案例2：在test.txt文件后面加上 hello word!
        		cat >> /root/test.txt <<EOF 
        		hello word! 
  基础变量
      $BASH              (Bash Shell全路径)
      $BASH_VERSION      (Bash Shell版本)
      $CDPATH            (快速进入目录)(例：CDPATH="/etc/sysconfig")
      $EUID              (显示当前用户ID)
      $FUNCNAME          (记录当前函数体的函数名)
      $HISTCMD           (记录下一条命令在history命令中的编号)
      $HISTFILE          (记录history命令记录文件位置)
      $HISTFILESIZE      (设置HISTFILE文件记录命令的行数)
      $HISTSIZE          (缓冲区大小)
      $HOSTNAME          (主机名)
      $HOSTTYPE          (主机架构)
      $MACHTYPE          (主机类型GNU标识)
      $LANG              (设置当前系统语言环境)
      $PWD               (记录当前目录)
      $OLDPWD            (记录之前目录)
      $PATH              (命令的搜索路径)
      $PS1               (命令提示符)
  运算    
      整数运算(let)例：let I=2+2
      位运算(左移 << 右移 >>)
        demo 例：let "value=4<<2" value=16  let "value=4>>2" value=1
      自增、自减(++/--)
      使用$[]做运算 例：$[5%2]
      使用expr做运算 例： expr 1+1
      内建运算命令(declare)(不使用declare命令 I=1+1 echo $I 结果为1+1，使用declare定义，结果为2)
      bc运算(支持非整数运算)(scale=3设置显示的小数位数)(支持逻辑运算 1为i真 0为i假)  
  杂项
      $()/`` 返回当前命令的执行结果并赋值给变量
      $0     脚本名本身
      $1     脚本的第一个参数
      $#     变量总数
      $*/$@  所有参数
      $?     前一个命令的退出返回值
      $!     最后一个后台进程的ID号
      $(date +%Y%m%d%H%M) 输出当前时间字符串
  测试
      test expression 测试结构  or  [expression]
      test file_operator FILE 文件测试方法
          文件测试                说明
          -b FILE            当文件存在且是个块 返回为真
          -c FILE            当文件存在且是个字符设备时 返回为真
          -d FILE            当文件存在且是个目录 返回为真
          -e FILE            当文件或者目录存在 返回为真
          -f FILE            当文件存在且为普通文件 返回为真
          -x FILE            当文件存在且为可执行文件 返回为真
          -w FILE            当文件存在且为可写文件 返回为真
          -r FILE            当文件存在且为可读文件 返回为真
          -l FILE            当文件存在且为连接文件 返回为真
          -p FILE            当文件存在且为管道文件 返回为真
          -s FILE            当文件存在且大小不为0时返回为真
          -S FILE            当文件存在且为soket文件时返回为真
          -g FILE            当文件存在且设置了SGID时 返回真
          -u FILE            当文件存在且设置了SUID时 返回真
          -k FILE            当文件存在且设置了sticky属性时 返回真
          -G FILE            当文件存在且属于有效用户组时 返回为真
          -O FILE            当文件存在且属于有效用户时 返回为真
          FILE1 -nt FILE2    当FILE1比FILE2新时返回为真
          FILE1 -ot FILE2    当FILE1比FILE2旧时返回为真
      字符串测试
          -z "string"        字符串string为空时返回真
          -n "string"        字符串string不为空时返回真
          "string1"="string2"字符串string1和string2相同时返回真
          "string1"!="string2"字符串string1和string2不相同时返回真
          "string1">"string2"按照字典排序 字符串string1在前时为真
          "string1"<"string2"按照字典排序 字符串string1在后时为真
      整数比较
          "num1" -eq "num2"  num1等于num2 返回为真
          "num1" -gt "num2"  num1大于num2 返回为真
          "num1" -lt "num2"  num1小于num2 返回为真
          "num1" -ge "num2"  num1大于等于num2 返回为真
          "num1" -le "num2"  num1小于等于num2 返回为真
          "num1" -ne "num2"  num1不等于num2 返回为真
      逻辑运算符
          ！expression       如果expression为真 返回假  !
          expression1 -a expression2 同时为真 返回真    &&
          expression1 -o expression2 只要有一个为真 返回真 ||
  判断    
      if判断
         if[expression]; then
            echo "if"
         fi   
      if/else判断
         if[expression]; then
             echo "if"
         else   
             echo "else"
         fi
      if/elif/else判断
         if[expression]; then
              echo "if"
         elif[expression]; then
              echo "elif"     
         else   
              echo "else"
         fi
      case判断
         case VAR in
         var1) command1 ;;
         var2) command1 ;;
         var3) command1 ;;
         ...
         *) command ;;
         esac
  循环
      for VARIABLE in list
        do
           command
        done   
      while expression
         do
           command
         done
      unitl expression     
         do
            command
         done   
      select MENU in list
         do
            command
         done  
  函数
  	 #shell中的默认常用函数
  	 	start stop restart
  	 
      FUNCTION_NAME(){
         command
      }
      function FUNCTION_NAME(){
          command
      }   