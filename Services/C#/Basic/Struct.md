# Struct 结构体
C# 结构体类型是用户自定义类型（用户根据需求，为了抽象描述一类事物的信息，组装一个行为的组合）
1. 结构体可以带有方法、构造函数、属性，可以不用new初始化
2. 静态结构体构造函数
    1. 必须为无参
    2. 必须不能有访问修饰符
    3. 执行时机：只有在调用结构体方法/函数的时候，才会被自动执行
3. Struct Example 
    1. 定义结构体
    ```c#
    struct Book {
        public string title;
        
        public string author;
        
        public string subject;
        
        public int id;
   
        public void print() {
            Debug.log("这是一本" + title);
        }
   
        
    }
    ```
    2. 使用结构体
    ```c#
    // 1. 初始化结构体
    Book chineseBook = new Book()
    chineseBook.id = 1;
    chineseBook.title = "语文书";
    chineseBook.print()
    
    // 2. 不初始化结构体
    Book englishBook;
    englishBook.id = 2;
    englishBook.title = "英语书";
    ```