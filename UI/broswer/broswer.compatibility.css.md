# 浏览器兼容
1. 为什么浏览器会出现不兼容的情况：
    - 浏览器使用的内核版本不同,
2. 如何使样式兼容所有浏览器或者极大部分浏览器:
```
/*1. CSS属性级Hack */
    color:red; /* 所有浏览器可识别*/
    _color:red; /* 仅IE6 识别 */
    *color:red; /* IE6、IE7 识别 */
    +color:red; /* IE6、IE7 识别 */
    *+color:red; /* IE6、IE7 识别 */
    [color:red; /* IE6、IE7 识别 */
    color:red\9; /* IE6、IE7、IE8、IE9 识别 */
    color:red\0; /* IE8、IE9 识别*/
    color:red\9\0; /* 仅IE9识别 */
    color:red \0; /* 仅IE9识别 */
    color:red!important; /* IE6 不识别!important 有危险*/
/* CSS选择符级Hack */
    *html #demo { color:red;} /* 仅IE6 识别 */
    *+html #demo { color:red;} /* 仅IE7 识别 */
    body:nth-of-type(1) #demo { color:red;} /* IE9+、FF3.5+、Chrome、Safari、Opera 可以识别 */
    head:first-child+body #demo { color:red; } /* IE7+、FF、Chrome、Safari、Opera 可以识别 */
    :root #demo { color:red\9; } : /* 仅IE9识别 */
```
## 阿里云浏览器样式兼容问题整理:
1. cursor:hand VS cursor:pointer
    - firefox不支持hand,但ie支持pointer
    - 解决方法: 统一使用pointer

2. innerText在IE中能正常工作,但在FireFox中却不行.
    - 需用textContent。
    - 解决方法:
    ```
    if(navigator.appName.indexOf("Explorer") > -1){ document.getElementById('element').innerText = "my text";} else{ document.getElementById('element').textContent = "my text";}
    ```
3. CSS透明
```
    IE:
    filter:progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=60)。
    FF:
    opacity:0.6
```
4. css中的width和padding
    - 在IE7和FF中width宽度不包括padding,在Ie6中包括padding.

5. FF和IEBOX模型解释不一致导致相差2px
    ```
        box.style{ width:100; border 1px;}
    ```
    - ie理解为box.width = 100
    - ff理解为box.width = 100 + 1*2 = 102 //加上边框2px
    1. 解决方法:
        ``` 
        div{ margin:30px!important; margin:28px;}
        ```
        - 注意这两个margin的顺序一定不能写反, IE不能识别!important这个属性,但别的浏览器可以识别。所以在IE下其实解释成这样:div{ margin:30px; margin:28px}
        重复定义的话按照最后一个来执行,所以不可以只写margin:XXpx!important;

6. IE5 和IE6的BOX解释不一致
    1. IE5下
        ```
        div{ width:300px; margin:0 10px 0 10px;}
        ````
        div 的宽度会被解释为300px-10px(右填充)-10px(左填充),最终div的宽度为280px,
    2. IE6和其他浏览器上宽度则是以 300px+10px(右填充)+10px(左填充)=320px来计算的。这时我们可以做如下修改
        ```
        div{ width:300px!important; width /**/:340px; margin:0 10px 0 10px}
        ```
7. ul和ol列表缩进问题
   1. 消除ul、ol等列表的缩进时,样式应写成:
      ```
      list-style:none;margin:0px;padding:0px;
      ```
      - 在IE中,设置margin:0px可以去除列表的上下左右缩进、空白以及列表编号或圆点,设置padding对样式没有影响;
      - 在 Firefox 中,设置margin:0px仅仅可以去除上下的空白,设置padding:0px后仅仅可以去掉左右缩进,还必须设置list- style:none才能去除列表编号或圆点。
      - 在IE中仅仅设置margin:0px即可达到最终效果,而在Firefox中必须同时设置margin:0px、 padding:0px以及list-style:none三项才能达到最终效果。

8. 元素水平居中问题
    FF: margin:0 auto;
    IE: 父级{ text-align:center; }

9. Div的垂直居中问题
    vertical-align:middle; 将行距增加到和整个DIV一样高:line-height:200px; 然后插入文字,就垂直居中了。
    缺点是要控制内容不要换行。

10. margin加倍的问题
    - 设置为float的div在ie下设置的margin会加倍。这是一个ie6都存在的bug。
    - 解决方案是在这个div里面加上display:inline;
    例如:
        ```
        <div id=”imfloat”>
        ```
    相应的css为#imfloat{ float:left; margin:5px;/*IE下理解为10px*/ display:inline;/*IE下再理解为5px*/}

11. IE与宽度和高度的问题
    IE不认得min-这个定义,但实际上它把正常的width和height当作有min的情况来使。这样问题就大了,如果只用宽度和高度,正常的浏览器里这两个值就不会变,
    如果只用min-width和min-height的话,IE下面根本等于没有设置宽度和高度。
    比如要设置背景图片,这个宽度是比较重要的。要解决这个问题,可以这样:
    ```
    #box{ width: 80px; height: 35px;}html#box{ >width: auto; height: auto; min-width: 80px; min-height: 35px;}
    ```
12. 页面的最小宽度
    - 如上一个问题,IE不识别min,要实现最小宽度,可用下面的方法:
    ```
    #container{ min-width: 600px; width:expression(document.body.clientWidth< 600?"600px": "auto" );}
    ```
    - 第一个min-width是正常的;但第2行的width使用了Javascript,这只有IE才认得,这也会让你的HTML文档不太正规。它实际上通过Javascript的判断来实现最小宽度。

13. DIV浮动IE文本产生3象素的bug
    - 左边对象浮动,右边采用外补丁的左边距来定位,右边对象内的文本会离左边有3px的间距.
    ```
    #box{ float:left; width:800px;} #left{ float:left; width:50%;} #right{ width:50%;} #left{ margin-right:-3px; //这句是关键} <div id="box"> <div id="left">
    ```
14. IE捉迷藏的问题
    当div应用复杂的时候每个栏中又有一些链接,DIV等这个时候容易发生捉迷藏的问题。
    有些内容显示不出来,当鼠标选择这个区域是发现内容确实在页面。
    解决办法:对#layout使用line-height属性或者给#layout使用固定高和宽。页面结构尽量简单。

15. float的div闭合;清除浮动;自适应高度
    1. 例如:
        这里的NOTfloatC并不希望继续平移,而是希望往下排。(其中floatA、floatB的属性已经设置为float:left;)
        这段代码在IE中毫无问题,问题出在FF。原因是NOTfloatC并非float标签,必须将float标签闭合。在
        之间加上这个div一定要注意位置,而且必须与两个具有float属性的div同级,之间不能存在嵌套关系,否则会产生异常。并且将clear这种样式定义为为如下即可:
        .clear{clear:both;}

    2. 作为外部 wrapper 的 div 不要定死高度,为了让高度能自适应,要在wrapper里面加上overflow:hidden; 当包含float的box的时候,高度自适应在IE下无效,
      这时候应该触发IE的layout私有属性(万恶的IE啊!)用zoom:1;可以做到,这样就达到了兼容。
    例如某一个wrapper如下定义:
        .colwrapper{overflow:hidden; zoom:1; margin:5px auto;}

    3. 对于排版,我们用得最多的css描述可能就是float:left.有的时候我们需要在n栏的float div后面做一个统一的背景,
    譬如: <div id=”page”> <div id=”left”>
    比如我们要将page的背景设置成蓝色,以达到所有三栏的背景颜色是蓝色的目的,但是我们会发现随着left center right的向下拉长,而page居然保存高度不变,
    问题来了,原因在于page不是float属性,而我们的page由于要居中,不能设置成float,所以我们应该这样解决:
    <div id=”page”> <div id=”bg” style=”float:left;width:100%”> <div id=”left”>
    再嵌入一个float left而宽度是100%的DIV解决之。

    4. 万能float 闭合(非常重要!)
    关于 clear float 的原理可参见 [How To Clear Floats Without Structural Markup],将以下代码加入Global CSS 中,给需要闭合的div加上class=”clearfix” 即可,屡试不爽。
    /* Clear Fix */ .clearfix:after { content:"."; display:block; height:0; clear:both; visibility:hidden; } .clearfix { display:inline-block; } /* Hide from IE Mac */ .clearfix { display:block;} /* End hide from IE Mac */ /* end of clearfix */
    或者这样设置:

    .hackbox{ display:table; //将对象作为块元素级的表格显示}
16. 高度不适应
    - 高度不适应是当内层对象的高度发生变化时外层高度不能自动进行调节,特别是当内层对象使用margin 或padding时。
    例:
    ```
    #box {background-color:#eee; } #box p {margin-top: 20px;margin-bottom: 20px; text-align:center; } <div id="box"> p对象中的内容
    ```
    - 解决技巧:在P对象上下各加2个空的div对象CSS代码{height:0px;overflow:hidden;}或者为DIV加上border属性。

17. IE6下图片下有空隙产生
    解决这个BUG的技巧有很多,可以是改变html的排版,或者设置img为display:block或者设置vertical-align属性为vertical-align:top/bottom/middle/text-bottom 都可以解决.

18. 对齐文本与文本输入框
    ```
    vertical-align:middle;<style type="text/css"><!--input { width:200px; height:30px; border:1px solid red; vertical-align:middle; } --></style>
    ```
    - 经验证,在IE下任一版本都不适用,而ff、opera、safari、chrome均可以。

19. LI中内容超过长度后以省略号显示
    - 此技巧适用与IE、Opera、safari、chrome浏览器,FF暂不支持。
    ```
    <style type="text/css"><!--li { width:200px; white-space:nowrap; text-overflow:ellipsis; -o-text-overflow:ellipsis; overflow: hidden; }--></style>
    ```
20. 为什么web标准中IE无法设置滚动条颜色了
    解决办法是将body换成html
    ```
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
        <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
        <style type="text/css">
        <!-- html
            { scrollbar-face-color:#f6f6f6; scrollbar-highlight-color:#fff; scrollbar-shadow-color:#eeeeee;
            scrollbar-3dlight-color:#eeeeee; scrollbar-arrow-color:#000; scrollbar-track-color:#fff;
             scrollbar-darkshadow-color:#fff; } -->
    ```
21. 为什么无法定义1px左右高度的容器
    1. IE6下这个问题是因为默认的行高造成的,解决的技巧也有很多:
       - 例如:
        ```
        overflow:hidden zoom:0.08 line-height:1px
        ```
    2. 怎么样才能让层显示在FLASH之上呢
        - 解决的办法是给FLASH设置透明
          ```
           <param name="wmode" value="transparent" />
          ```

22. 链接(a标签)的边框与背景
    a链接加边框和背景色,需设置 display: block, 同时设置 float: left 保证不换行。参照menubar, 给 a 和menubar设置高度是为了避免底边显示错位, 若不设 height, 可以在menubar中插入一个空格。

23. 超链接访问过后hover样式就不出现的问题
    被点击访问过的超链接样式不在具有hover和active了,很多人应该都遇到过这个问题,解决技巧是改变CSS属性的排列顺序: L-V-H-A
    ```
    Code:<style type="text/css"><!--a:link {} a:visited {} a:hover {} a:active {} --></style>
    ```
24. FORM标签
    这个标签在IE中,将会自动margin一些边距,而在FF中margin则是0,因此,如果想显示一致,所以最好在css中指定margin和 padding,针对上面两个问题,我的css中一般首先都使用这样的样式ul,form{margin:0;padding:0;}。

25. 属性选择器(这个不能算是兼容,是隐藏css的一个bug)
    ```
    p[id]{}div[id]{}
    ```
    这个对于IE6.0和IE6.0以下的版本都隐藏,FF和OPera作用.属性选择器和子选择器还是有区别的,子选择器的范围从形式来说缩小了,属性选择器的范围比较大,如p[id]中,所有p标签中有id的都是同样式的.

26. 为什么FF下文本无法撑开容器的高度
    标准浏览器中固定高度值的容器是不会象IE6里那样被撑开的,那我又想固定高度,又想能被撑开需要怎样设置呢?办法就是去掉height设置min-height:200px;
    这里为了照顾不认识min-height的IE6 可以这样定义:
    ```
    { height:auto!important; height:200px; min-height:200px; }
    ```
27、不同浏览器的标签默认的外补丁和内补丁不同
    问题症状:随便写几个标签,不加样式控制的情况下,各自的margin 和padding差异较大。
    解决方案:CSS里 *{margin:0;padding:0;}
    备注:这个是最常见的也是最易解决的一个浏览器兼容性问题,几乎所有的CSS文件开头都会用通配符*来设置各个标签的内外补丁是0。

28、透明度的兼容CSS设置
    做兼容页面的方法是:
    每写一小段代码(布局中的一行或者一块)我们都要在不同的浏览器中看是否兼容,当然熟练到一定的程度就没这么麻烦了。建议经常会碰到兼容性问题的新手使用。
    很多兼容性问题都是因为浏览器对标签的默认属性解析不同造成的,只要我们稍加设置都能轻松地解决这些兼容问题。如果我们熟悉标签的默认属性的话,就能很好的理解为什么会出现兼容问题以及怎么去解决这些兼容问题。
    /* CSS hack*/
    我很少使用hacker的,可能是个人习惯吧,我不喜欢写的代码IE不兼容,然后用hack来解决。不过hacker还是非常好用的。使用hacker我可以把浏览器分为3类:IE6 ;IE7和遨游;其他(IE8 chrome ff safari opera等)
    ◆IE6认识的hacker 是下划线_ 和星号 *
    ◆IE7 遨游认识的hacker是星号 *
    比如这样一个CSS设置:
    height:300px;*height:200px;_height:100px;
    IE6浏览器在读到height:300px的时候会认为高时300px;继续往下读,他也认识*heihgt, 所以当IE6读到*height:200px的时候会覆盖掉前一条的相冲突设置,认为高度是200px。继续往下读,IE6还认识_height,所以他又会覆盖掉200px高的设置,把高度设置为100px;
IE7和遨游也是一样的从高度300px的设置往下读。当它们读到*height200px的时候就停下了,因为它们不认识_height。所以它们会把高度解析为200px,剩下的浏览器只认识第一个height:300px;所以他们会把高度解析为300px。因为优先级相同且想冲突的属性设置后一个会覆盖掉前一个,所以书写的次序是很重要的。

29. 标签最低高度设置min-height不兼容
    问题症状:因为min-height本身就是一个不兼容的CSS属性,所以设置min-height时不能很好的被各个浏览器兼容
    解决方案:如果我们要设置一个标签的最小高度200px,需要进行的设置为:
    { min-height:200px; height:auto !important; height:200px; overflow:visible;}
    备注:在B/S系统前端开时,有很多情况下我们又这种需求。当内容小于一个值(如300px)时。容器的高度为300px;当内容高度大于这个值时,容器高度被撑高,而不是出现滚动条。这时候我们就会面临这个兼容性问题。

30. 块属性标签float后,又有横行的margin情况下,在IE6显示margin比设置的大
    问题症状:常见症状是IE6中后面的一块被顶到下一行(稍微复杂点的页面都会碰到,float布局最常见的浏览器兼容问题)
    解决方案:在float的标签样式控制中加入 display:inline;将其转化为行内属性
    备注:我们最常用的就是div+CSS布局了,而div就是一个典型的块属性标签,横向布局的时候我们通常都是用div float实现的,横向的间距设置如果用margin实现,这就是一个必然会碰到的兼容性问题。

31. 设置较小高度标签(一般小于10px),在IE6,IE7,遨游中高度超出自己设置高度
    问题症状:IE6、7和遨游里这个标签的高度不受控制,超出自己设置的高度
    解决方案:给超出高度的标签设置overflow:hidden;或者设置行高line-height 小于你设置的高度。
    备注:这种情况一般出现在我们设置小圆角背景的标签里。出现这个问题的原因是IE8之前的浏览器都会给标签一个最小默认的行高的高度。即使你的标签是空的,这个标签的高度还是会达到默认的行高。

32. 行内属性标签,设置display:block后采用float布局,又有横行的margin的情况,IE6间距bug
    问题症状:IE6里的间距比超过设置的间距
    解决方案:在display:block;后面加入display:inline;display:table;
    备注:
        行内属性标签,为了设置宽高,我们需要设置display:block;(除了input标签比较特殊)。在用float布局并有横向的margin后,在IE6下,
        他就具有了块属性float后的横向margin的bug。不过因为它本身就是行内属性标签,所以我们再加上display:inline的话,它的高宽就不可设了。
        这时候我们还需要在display:inline后面加入display:talbe。

33. 图片默认有间距
  - 问题症状:几个img标签放在一起的时候,有些浏览器会有默认的间距,加了 *{margin:0;padding:0;}的通配符也不起作用。
  - 解决方案:使用float属性为img布局
  - 备注:因为img标签是行内属性标签,所以只要不超出容器宽度,img标签都会排在一行里,但是部分浏览器的img标签之间会有个间距。去掉这个间距使用float是正道。(我的一个学生使用负margin,虽然能解决,但负margin本身就是容易引起浏览器兼容问题的用法,所以我禁止他们使用)

34. IE6不支持fixed
```
    /*对于非IE6可以这样写*/#top{ position:fixed; bottom:0; right:20px; }
    /*但是IE6是不支持fixed定位的,需要另外重写*/#top{ position:fixed; _position:absolute; top:0; right:20px; _bottom:auto; _top:expression(eval(document.documentElement.scrollTop));}
    /*使用hack使IE6实现该效果,但这个东东会闪烁,需要以下代码*/*html{ background-image:url(about:blank); background-attachment:fixed; }
    /*使固定在顶部*/#top{ _position:absolute; _bottom:auto; _top:expression(eval(document.documentElement.scrollTop)); }
    /*固定在底部*/#top{ _position:absolute; _bottom:auto; _top:expression(eval(document.documentElement.scrollTop+document.documentElement.clientHeight-this.offsetHeight-(parseInt(this.currentStyle.marginTop)||0)-(parseInt(this.currentStyle.marginBottom)||0))); }
    /*垂直居中*/#top{ position:fixed; top:50%; margin-top:-50px; _position:absolute; _top:expression(eval(document.documentElement.scrollTop+document.documentElement.clientHeight/2)); }
```
35. 解决IE6最大最小宽高hack方法
```
    /* 最小宽度 */.min_width{ min-width:300px; _width:expression(parseInt(this.clientWidth) < 300 ? "300px" : this.clientWidth);}
    /* 最大宽度 */.max_width{ max-width:600px; _width:expression(parseInt(this.clientWidth) > 600 ? "600px" : this.clientWidth);}
    /* 最小高度 */.min_height{ min-height:200px; _height:expression(parseInt(this.clientHeight) < 200 ? "200px" : this.clientHeight);}
    /* 最大高度 */.max_height{ max-height:400px; _height:expression(parseInt(this.clientHeight) > 400 ? "400px" : this.clientHeight);}
```
36. z-index不起作用的BUG
    1. ie6下 首先讲讲第一种z-index无论设置多高都不起作用情况。
        1. 父标签position属性为relative;
        2. 问题标签含有浮动(float)属性。
    2. 所有浏览器:
        1. 它只认第一个爸爸层级的高低不仅要看自己,还要看自己的老爸这个后台是否够硬。
        用术语具体描述为:父标签position属性为relative或absolute时,子标签的absolute属性是相对于父标签而言的。
        而在IE6下,层级的表现有时候不是看子标签的z-index多高,而要看它们的父标签的z-index谁高谁低。

37. IE各版本的hack
```
/*类内部hack:*/ .header {_width:100px;}
/* IE6专用*/ .header {*+width:100px;}
/* IE7专用*/ .header {*width:100px;}
/* IE6、IE7共用*/ .header {width:100px/0;}
/* IE8、IE9共用*/ .header {width:100px/9;}
/* IE6、IE7、IE8、IE9共用*/ .header {width:330px/9/0;}
/* IE9专用*/ /*选择器Hack:*/ *html .header{}
/*IE6*/ *+html .header{}/*IE7*/
```