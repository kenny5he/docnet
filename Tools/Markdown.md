---
title: Markdown语法
date: 2019-03-18 10：10：10
comments: false
---

##### 标题信息
[^_^]:
    注释信息:标题最后一个#号后需留一空格
##### 字体信息
*斜体*
**加粗**
***斜体加粗 ***
~~删除线~~

缩进换行
```
&ensp;或&#8194; //半角
&emsp;或&#8195; //全角
&nbsp;或&#160;
<br/> //换行
```

##### 数学公式
[blog](https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference)
$$\sum_{i=0}^n i^2 = \frac{(n^2+n)(2n+1)}{6}$$

------
[^_^]:
    注释信息:分割线:三个或者三个以上的-或者*

>>> 引用1
>>>> 引用2

##### 图片、超链接
![image](/knote/img/xxx.jpg "image")
[link](https://www.google.com.hk)
##### 表格信息


|表头|表头|表头|
|---|:--:|---:|
|内容|内容|内容|
|内容|内容|内容|


[^_^]:
    注释信息:第二行分割表头和内容,-号有一个就行
[^_^]:
    注释信息:为了对齐，多加了几个,文字默认居左,-两边加：表示文字居中,-右边加：表示文字居右。注：原生的语法两边都要用|号包起来。此处省略

##### 列表信息
###### 无序列表
- 列表内容
+ 列表内容
* 列表内容
[^_^]:
    注意：-号、+号、*号跟内容之间都要有一个空格(-/+/*均可)①②③④⑤⑥⑦⑧⑨⑩
###### 有序列表
1. 列表内容
    1. 有序列表子集
        1. 有序列表子集的子集
        2. 有序列表子集的子集
    2. 有序列表子集
    3. 有序列表子集
2. 列表内容
3. 列表内容
[^_^]:
    注意：序号跟内容之间要有空格,上一级和下一级之间敲三个空格即可

##### 流程图
blog: https://cloud.tencent.com/developer/article/1142260

```flow
st=>start: Start:>http://www.google.com[blank]
e=>end:>http://www.google.com
op1=>operation: My Operation
sub1=>subroutine: My Subroutine
cond=>condition: Yes
or No?:>http://www.google.com
io=>inputoutput: catch something...

st->op1->cond
cond(yes)->io->e
cond(no)->sub1(right)->op1
```