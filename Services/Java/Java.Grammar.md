# Java 语法
1. for/foreach/iterator的区别
    1. 形式的区别:
        - for
        ```
        for(int i=0;i<arr.size();i++){}
        ```
        - foreach
        ```
            foreach(int i: arr){}
        ```
        - iterator
        ```
        Iterator it = arr.iterator();
        while(it.hasNext()){object o =it.next();}
        ```
          
    2. 条件差别
        - for 需要集合或数组/集合的大小，并有序
        - foreach/iterator 无需知数组/集合大小，
    3. 多态差别
        - for/foreach 都必须先知道集合类型，需要访问内部的成员，不能实现多态
        - iterator 是一个接口类型，它不关心集合或者数组的类，能随时修改和删除集合的元素
