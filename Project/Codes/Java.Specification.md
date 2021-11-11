#通用代码规范
## 命名
1. 源文件编码格式必须是UTF-8，ASCII水平空格字符(0X20)是唯一允许的空白字符，制表符不用于缩进
2. 所有标识符仅适用ASCII字母和数字，名称由正则表达式匹配
3. 包名称以小写点号隔开，以com.公司域名开头
4. 枚举和接口采用首字母大写的骆驼命名法
5. 方法名采用首写字母小写的骆驼命名法
6. 常量名称全大写，单词以下划线分隔
7. 非常量字段名称采用首写字母小写的骆驼命名法
8. 避免使用否定的布尔命名

## 注释
1. Javadoc用于每一个public或protected修饰元素
2. 对于方法有参数、返回值、异常信息时，必须在Javadoc块中描述: 功能、@param @return @throws等
3. 文件头注释必须包含版权许可，顶层public类头有功能说明，创建日期
4. Javadoc标签与内容之间只1个空格，按@param @return @throws顺序排序
5. 禁止有空方法头注释
6. Javadoc 注释正文与其下的各个Tag之间加1个空行，类级成员注释与上面代码之间有一个空行，注释符与注释内容之间要有1个空格，右注释与前面代码至少1空格
7. 不用的代码删除，不要注释掉
8. 正式交付客户的代码不应该包含Todo/FixMe注释

## 排版
1. 规则
   1. 避免文件过长，不超过2000行(非空菲注释行)
   2. 一个源文件按顺序包含版权、package、 import、顶层类，且用空行分隔
   3. 在条件语句或循环块中必须使用大括号
   4. 对于非空块和块结构，左大括号放行尾
   5. 使用空格缩进，每次缩进4格
   6. 每行不超过一个语句
   7. 每行限长120个字符
   8. 换行起点在点号、双冒号、类型&、catch块中管道之前，在方法左括号、逗号、lamda箭头和其左大括号之后
   9. 减少不必要空行，保持代码紧凑
   10. 不应插入空格水平对齐
   11. 枚举常量间用逗号隔开，换行可选
   12. 每行声明一个变量
   13. 变量被声明在接近它们首次使用的行
   14. 禁止C风格的数组声明
   15. case语句块结束时，如果不加break，必须要有注释说明
   16. switch语句要有default分支，除非switch的条件变量是枚举类型
   17. 应用于类，方法或构造方法的每个注释独占一行
   18. 类和成员注释符 按java语言规范建议的顺序显示
   19. 数字字面量以大写字母为后缀
   20. 行尾和空行不能有空格space，二元/三元或类似运算符的两侧 使用空格
2. 建议
   1. import应当先按安卓，(公司域名)、其它商业组织，其它开源第三方、net/org 开源组织，最后java的分类顺序出现，并用一个空行分组
   2. 一个类或接口的声明部分应当按照类变量、实例变量、构造器、方法的顺序出现
   3. 应该避免空块，多块的右大括号应该新起一行

## 变量和类型
1. 规则
   1. 不能用浮点数作为循环变量
   2. 需要精确计算时不要使用float和double
   3. 浮点型数据判断相等不能直接使用==
      4.禁止尝试与NaN进行比较运算，相等操作使用Float或Double的isNaN方法
   4. 不要在单个的表达式中对相同的变量赋值超过一次
2. 建议
   1. 向下类型转换前用instanceof判断
   2. 基本类型优于包装类型，注意合理使用包装类型
   3. 明确的进行类型转换，不要依赖隐式类型转换

## 方法
1. 规则
   1. 避免方法过长，不要超过50行
   2. 避免方法嵌套过深，不要超过4层
   3. 使用类名调用静态方法，而不是使用实例或表达式调用
2. 建议
   1. 不要把方法的入参当做工作变量或者临时变量
   2. 方法的参数个数不应超过5个
   3. 谨慎使用不可变数量参数的方法
   4. 构造方法如果参数过多，尽量重用
   5. 对于返回数组或者容器的方法，应返回长度为0的数组或者容器，代替返回null

## 类和接口
1. 规则
   1. 避免在无关的变量或无关的概念之间重用名字，避免隐藏hide，遮蔽 shadow，掩饰 obscure
   2. 不要在父类的构造方法中调用可能被子类覆写的方法
   3. 覆写equals方法时，应同时覆写hashcode方法
   4. 子类覆写父类方法时应加上@Override注解
2. 建议
   1. 避免public且final的成员字段定义
   2. 避免基本类型与其包装类型的同名重载方法
   3. 接口定义去掉多余的修饰词
   4. Java8中可在接口中加上静态方法表示相关工厂或助手方法

## 其它
1. 规则

2. 建议