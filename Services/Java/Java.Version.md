##### JDK1.5新特性：
1. 自动装箱与拆箱：
    自动装箱的过程：每当需要一种类型的对象时，这种基本类型就自动地封装到与它相同类型的包装中。
    自动拆箱的过程：每当需要一个值时，被装箱对象中的值就被自动地提取出来，没必要再去调用intValue()和doubleValue()方法。
    自动装箱，只需将该值赋给一个类型包装器引用，java会自动创建一个对象。
    自动拆箱，只需将该对象值赋给一个基本类型即可。
    java——类的包装器
    类型包装器有：Double,Float,Long,Integer,Short,Character和Boolean
2. 枚举
    把集合里的对象元素一个一个提取出来。枚举类型使代码更具可读性，理解清晰，易于维护。枚举类型是强类型的，从而保证了系统安全性。而以类的静态字段实现的类似替代模型，不具有枚举的简单性和类型安全性。
    简单的用法：JavaEnum简单的用法一般用于代表一组常用常量，可用来代表一类相同类型的常量值。
    复杂用法：Java为枚举类型提供了一些内置的方法，同时枚举常量还可以有自己的方法。可以很方便的遍历枚举对象。
3. 静态导入
    通过使用 import static，就可以不用指定 Constants 类名而直接使用静态成员，包括静态方法。
    import xxxx 和 import static xxxx的区别是前者一般导入的是类文件如import java.util.Scanner;后者一般是导入静态的方法，import static java.lang.System.out。
4. 可变参数（Varargs）
    可变参数的简单语法格式为：
    methodName([argumentList], dataType...argumentName);
5. 内省（Introspector）
    Java语言对Bean类属性、事件的一种缺省处理方法。
    例如类A中有属性name,那我们可以通过getName,setName来得到其值或者设置新 的值。通过getName/setName来访问name属性，这就是默认的规则。
    Java中提供了一套API用来访问某个属性的getter /setter方法，通过这些API可以使你不需要了解这个规则（但你最好还是要搞清楚），这些API存放于包java.beans中。
    一般的做法是通过类Introspector来获取某个对象的BeanInfo信息，然后通过BeanInfo来获取属性的描述器 （PropertyDescriptor），
    通过这个属性描述器就可以获取某个属性对应的getter/setter方法，然后我们就可以通过反射机制来 调用这些方法。
6. 泛型(Generic)
    C++ 通过模板技术可以指定集合的元素类型，而Java在1.5之前一直没有相对应的功能。一个集合可以放任何类型的对象，
    相应地从集合里面拿对象的时候我们也 不得不对他们进行强制得类型转换。猛虎引入了泛型，它允许指定集合里元素的类型，
    这样你可以得到强类型在编译时刻进行类型检查的好处。
7. For-Each循环
    For-Each循环得加入简化了集合的遍历。假设我们要遍历一个集合对其中的元素进行一些处理。
##### JDK 1.6新特性
1. Desktop类和SystemTray类
    在JDK6中 ,AWT新增加了两个类:Desktop和SystemTray。
    Desktop可以用来打开系统默认浏览器浏览指定的URL,打开系统默认邮件客户端给指定的邮箱发邮件,用默认应用程序打开或编辑文件(比如,用记事本打开以txt为后缀名的文件),用系统默认的打印机打印文档;
    SystemTray可以用来在系统托盘区创建一个托盘程序.
2. 使用JAXB2来实现对象与XML之间的映射
    JAXB是Java Architecture for XML Binding的缩写，可以将一个Java对象转变成为XML格式，反之亦然。
    我 们把对象与关系数据库之间的映射称为ORM, 其实也可以把对象与XML之间的映射称为OXM(Object XML Mapping).
    原来JAXB是Java EE的一部分，在JDK6中，SUN将其放到了Java SE中，这也是SUN的一贯做法。JDK6中自带的这个JAXB版本是2.0, 比起1.0(JSR 31)来，
    JAXB2(JSR 222)用JDK5的新特性Annotation来标识要作绑定的类和属性等，这就极大简化了开发的工作量。
    实 际上，在Java EE 5.0中，EJB和Web Services也通过Annotation来简化开发工作。另外,JAXB2在底层是用StAX(JSR 173)来处理XML文档。除了JAXB之外，我们还可以通过XMLBeans和Castor等来实现同样的功能。
3. 理解StAX
    StAX(JSR 173)是JDK6.0中除了DOM和SAX之外的又一种处理XML文档的API。
    StAX 的来历 ：在JAXP1.3(JSR 206)有两种处理XML文档的方法:DOM(Document Object Model)和SAX(Simple API for XML).
    由 于JDK6.0中的JAXB2(JSR 222)和JAX-WS 2.0(JSR 224)都会用到StAX所以Sun决定把StAX加入到JAXP家族当中来，并将JAXP的版本升级到1.4(JAXP1.4是JAXP1.3的维护版 本). JDK6里面JAXP的版本就是1.4. 。
    StAX是The Streaming API for XML的缩写，一种利用拉模式解析(pull-parsing)XML文档的API.StAX通过提供一种基于事件迭代器(Iterator)的API让 程序员去控制xml文档解析过程,程序遍历这个事件迭代器去处理每一个解析事件，解析事件可以看做是程序拉出来的，也就是程序促使解析器产生一个解析事件 然后处理该事件，之后又促使解析器产生下一个解析事件，如此循环直到碰到文档结束符；
    SAX也是基于事件处理xml文档，但却 是用推模式解析，解析器解析完整个xml文档后，才产生解析事件，然后推给程序去处理这些事件；DOM 采用的方式是将整个xml文档映射到一颗内存树，这样就可以很容易地得到父节点和子结点以及兄弟节点的数据，但如果文档很大，将会严重影响性能。
4. 使用Compiler API
    现在我 们可以用JDK6 的Compiler API(JSR 199)去动态编译Java源文件，Compiler API结合反射功能就可以实现动态的产生Java代码并编译执行这些代码，有点动态语言的特征。
    这个特性对于某些需要用到动态编译的应用程序相当有用， 比如JSP Web Server，当我们手动修改JSP后，是不希望需要重启Web Server才可以看到效果的，这时候我们就可以用Compiler API来实现动态编译JSP文件，当然，现在的JSP Web Server也是支持JSP热部署的，现在的JSP Web Server通过在运行期间通过Runtime.exec或ProcessBuilder来调用javac来编译代码，这种方式需要我们产生另一个进程去 做编译工作，不够优雅而且容易使代码依赖与特定的操作系统；Compiler API通过一套易用的标准的API提供了更加丰富的方式去做动态编译,而且是跨平台的。
5. 轻量级Http Server API
    JDK6 提供了一个简单的Http Server API,据此我们可以构建自己的嵌入式Http Server,它支持Http和Https协议,提供了HTTP1.1的部分实现，没有被实现的那部分可以通过扩展已有的Http Server API来实现,程序员必须自己实现HttpHandler接口,HttpServer会调用HttpHandler实现类的回调方法来处理客户端请求,在 这里,我们把一个Http请求和它的响应称为一个交换,包装成HttpExchange类,HttpServer负责将HttpExchange传给 HttpHandler实现类的回调方法.
6. 插入式注解处理API(Pluggable Annotation Processing API)
    插入式注解处理API(JSR 269)提供一套标准API来处理Annotations(JSR 175)
    实 际上JSR 269不仅仅用来处理Annotation,我觉得更强大的功能是它建立了Java 语言本身的一个模型,它把method, package, constructor, type, variable, enum, annotation等Java语言元素映射为Types和Elements(两者有什么区别?), 从而将Java语言的语义映射成为对象, 我们可以在javax.lang.model包下面可以看到这些类. 所以我们可以利用JSR 269提供的API来构建一个功能丰富的元编程(metaprogramming)环境.
    JSR 269用Annotation Processor在编译期间而不是运行期间处理Annotation, Annotation Processor相当于编译器的一个插件,所以称为插入式注解处理.如果Annotation Processor处理Annotation时(执行process方法)产生了新的Java代码,编译器会再调用一次Annotation Processor,如果第二次处理还有新代码产生,就会接着调用Annotation Processor,直到没有新代码产生为止.每执行一次process()方法被称为一个"round",这样整个Annotation processing过程可以看作是一个round的序列.
    JSR 269主要被设计成为针对Tools或者容器的API. 举个例子,我们想建立一套基于Annotation的单元测试框架(如TestNG),在测试类里面用Annotation来标识测试期间需要执行的测试方法。

7. 用Console开发控制台程序
    JDK6 中提供了java.io.Console 类专用来访问基于字符的控制台设备. 你的程序如果要与Windows下的cmd或者Linux下的Terminal交互,就可以用Console类代劳. 但我们不总是能得到可用的Console, 一个JVM是否有可用的Console依赖于底层平台和JVM如何被调用. 如果JVM是在交互式命令行(比如Windows的cmd)中启动的,并且输入输出没有重定向到另外的地方,那么就可以得到一个可用的Console实 例.

8. 对脚本语言的支持如: ruby, groovy, javascript.
9. Common Annotations
    Common annotations原本是Java EE 5.0(JSR 244)规范的一部分，现在SUN把它的一部分放到了Java SE 6.0中.
    随 着Annotation元数据功能(JSR 175)加入到Java SE 5.0里面，很多Java 技术(比如EJB,Web Services)都会用Annotation部分代替XML文件来配置运行参数（或者说是支持声明式编程,如EJB的声明式事务）, 如果这些技术为通用目的都单独定义了自己的Annotations,显然有点重复建设, 所以,为其他相关的Java技术定义一套公共的Annotation是有价值的，可以避免重复建设的同时，也保证Java SE和Java EE 各种技术的一致性.
    下面列举出Common Annotations 1.0里面的10个Annotations Common Annotations
    Annotation Retention Target Description
    Generated Source ANNOTATION_TYPE, CONSTRUCTOR, FIELD, LOCAL_VARIABLE, METHOD, PACKAGE, PARAMETER, TYPE 用于标注生成的源代码
    Resource Runtime TYPE, METHOD, FIELD 用于标注所依赖的资源,容器据此注入外部资源依赖，有基于字段的注入和基于setter方法的注入两种方式
    Resources Runtime TYPE 同时标注多个外部依赖，容器会把所有这些外部依赖注入
    PostConstruct Runtime METHOD 标注当容器注入所有依赖之后运行的方法，用来进行依赖注入后的初始化工作，只有一个方法可以标注为PostConstruct
    PreDestroy Runtime METHOD 当对象实例将要被从容器当中删掉之前，要执行的回调方法要标注为PreDestroy RunAs Runtime TYPE 用于标注用什么安全角色来执行被标注类的方法，这个安全角色必须和Container 的Security角色一致的。RolesAllowed Runtime TYPE, METHOD 用于标注允许执行被标注类或方法的安全角色，这个安全角色必须和Container 的Security角色一致的
    PermitAll Runtime TYPE, METHOD 允许所有角色执行被标注的类或方法
    DenyAll Runtime TYPE, METHOD 不允许任何角色执行被标注的类或方法，表明该类或方法不能在Java EE容器里面运行
    DeclareRoles Runtime TYPE 用来定义可以被应用程序检验的安全角色，通常用isUserInRole来检验安全角色

    注意:
    1.RolesAllowed,PermitAll,DenyAll不能同时应用到一个类或方法上
    2.标注在方法上的RolesAllowed,PermitAll,DenyAll会覆盖标注在类上的RolesAllowed,PermitAll,DenyAll
    3.RunAs,RolesAllowed,PermitAll,DenyAll和DeclareRoles还没有加到Java SE 6.0上来
    4. 处理以上Annotations的工作是由Java EE容器来做, Java SE 6.0只是包含了上面表格的前五种Annotations的定义类,并没有包含处理这些Annotations的引擎,这个工作可以由Pluggable Annotation Processing API(JSR 269)来做
    改动的地方最大的就是java GUI界面的显示了，JDK6.0（也就是JDK1.6）支持最新的windows vista系统的Windows Aero视窗效果，而JDK1.5不支持！！！
你要在vista环境下编程的话最好装jdk6.0，否则它总是换到windows basic视窗效果.

##### JDK 1.7 新特性
1. switch中可以使用字串
2. "<>"这个玩意儿的运用List<String> tempList = new ArrayList<>(); 即泛型实例化类型自动推断
3. 自定义自动关闭类(AutoCloseable)
4. 新增一些取环境信息的工具方法
    File System.getJavaIoTempDir() // IO临时文件夹
    File System.getJavaHomeDir() // JRE的安装目录
    File System.getUserHomeDir() // 当前用户目录
    File System.getUserDir() // 启动java进程时所在的目录
5. Boolean类型反转，空指针安全,参与位运
6. 两个char间的equals
7. 安全的加减乘除
    int Math.safeToInt(long value)
    int Math.safeNegate(int value)
    long Math.safeSubtract(long value1, int value2)
    long Math.safeSubtract(long value1, long value2)
    int Math.safeMultiply(int value1, int value2)
    long Math.safeMultiply(long value1, int value2)
    long Math.safeMultiply(long value1, long value2)
    long Math.safeNegate(long value)
    int Math.safeAdd(int value1, int value2)
    long Math.safeAdd(long value1, int value2)
    long Math.safeAdd(long value1, long value2)
    int Math.safeSubtract(int value1, int value2)
8. 对Java集合（Collections）的增强支持
    摒弃了Java集合接口的实现类，如：ArrayList、HashSet和HashMap。而是直接采用[]、{}的形式存入对象，采用[]的形式按照索引、键值来获取集合中的对象
    List<String> list=["item"]; //向List集合中添加元素
    Set<String> set={"item"}; //向Set集合对象中添加元素
    Map<String,Integer> map={"key":1}; //向Map集合中添加对象
9. 数值可加下划线
    例如：int one_million = 1_000_000;
10. 支持二进制文字
    int binary = 0b1001_1001;
11. 简化了可变参数方法的调用
    当程序员试图使用一个不可具体化的可变参数并调用一个*varargs* （可变）方法时，编辑器会生成一个“非安全操作”的警告。
12. 在try catch异常扑捉中，一个catch可以写多个异常类型，用"|"隔开，
13. 不必要写finally语句来关闭资源，只要你在try()的括号内部定义要使用的资源
    import java.io.*;
    // Copy from one file to another file character by character.
    // JDK 7 has a try-with-resources statement, which ensures that
    // each resource opened in try() is closed at the end of the statement.
    public class FileCopyJDK7 {
       public static void main(String[] args) {
          try (BufferedReader in  = new BufferedReader(new FileReader("in.txt"));
               BufferedWriter out = new BufferedWriter(new FileWriter("out.txt"))) {
             int charRead;
             while ((charRead = in.read()) != -1) {
                System.out.printf("%c ", (char)charRead);
                out.write(charRead);
             }
          } catch (IOException ex) {
             ex.printStackTrace();
          }
       }
    }
jdk1.8优势:
    速度更快
    代码更少(Lambda表达式)
    强大的Stream API
    便于运行
    最大化减少空指针异常 Optional
##### Stream blog:  https://www.cnblogs.com/andywithu/p/7404101.html
##### jdk1.8新特性:
1. 接口允许有默认实现方法:
    给接口添加一个非抽象的方法实现，只需要使用 default关键字即可，这个特征又叫做扩展方法
2. Lambda 表达式(匿名函数)(Java8 核心特性)
    Compare示例:
        Old
            List<String> names = Arrays.asList("peter", "anna", "mike", "xenia");
            Collections.sort(names, new Comparator<String>() {
                @Override
                public int compare(String a, String b) {
                    return b.compareTo(a);
                }
            });
        New1
            List<String> names = Arrays.asList("peter", "anna", "mike", "xenia");
            Collections.sort(names, (String a, String b) -> {
                return b.compareTo(a);
            });
        New2
            对于函数体只有一行代码的，可以去掉大括号{}以及return关键字,通过上下文进行"类型推断" 即可无需定义a/b的类型
            List<String> names = Arrays.asList("peter", "anna", "mike", "xenia");
            Collections.sort(names, (a, b) -> b.compareTo(a));
    Runable示例:
        Old:
            Runable r = new Runable(){

                @override
                public void run(){
                    System.out.print("Hello Lambda");
                }
            };
            r.run()
        New:(对方法默认实现，有参，无返回，案例)
            Runable r = () -> System.out.print("Hello Lambda");
            r.run();

3. 函数式接口
    Lambda 表达式是如何在java的类型系统中表示的呢？每一个lambda表达式都对应一个类型，通常是接口类型。
    而“函数式接口”是指仅仅只包含一个抽象方法的 接口，每一个该类型的lambda表达式都会被匹配到这个抽象方法。
    因为 默认方法 不算抽象方法，所以你也可以给你的函数式接口添加默认方法。
    我们可以将lambda表达式当作任意只包含一个抽象方法的接口类型，确保你的接口一定达到这个要求，
    你只需要给你的接口添加 @FunctionalInterface 注解，编译器如果发现你标注了这个注解的接口有多于一个抽象方法的时候会报错的。
    示例:
        @FunctionalInterface
        interface Converter<F, T> {
            T convert(F from);
        }
        Converter<String, Integer> converter = (from) -> Integer.valueOf(from);
        Integer converted = converter.convert("123");
        System.out.println(converted);    // 123
4. 方法与构造函数引用
    :: 关键字来传递方法或者构造函数引用
        引用静态方法示例:
            Converter<String, Integer> converter = Integer::valueOf;
            Integer converted = converter.convert("123");
            System.out.println(converted);   // 123
        引用一个对象的方法示例:
            converter = something::startsWith;
            String converted = converter.convert("Java");
            System.out.println(converted);    // "J"
        引用构造函数示例:
            class Person {
                @Getter
                @Setter
                String nikeName;

                @Getter
                @Setter
                Integer age;

                Person() {}

                Person(String nikeName, Integer age) {
                    this.nikeName = nikeName;
                    this.age = age;
                }
            }
            interface PersonFactory<P extends Person> {
                P create(String nikeName, Integer age);
            }
            PersonFactory<Person> personFactory = Person::new;
            Person person = personFactory.create("Peter", 18);
5. Lambda 作用域
    在lambda表达式中访问外层作用域和老版本的匿名对象中的方式很相似。你可以直接访问标记了final的外层局部变量，或者实例的字段以及静态变量。

6. 访问局部变量
    在lambda表达式中访问外层的局部变量,外层局部变量无需加final关键字，(当未添加final的变量定义被lambda内部调用时，变量隐式为final，不可再重新赋值)
7. 访问对象字段与静态变量
    和本地变量不同的是，lambda内部对于实例的字段以及静态变量是即可读又可写。该行为和匿名对象是一致的：
8. 访问接口的默认方法
    在老Java中常用到的比如Comparator或者Runnable接口，这些接口都增加了@FunctionalInterface注解以便能用在lambda上。
    Java 8 API同样还提供了很多全新的函数式接口来让工作更加方便，有一些接口是来自Google Guava库里的，
    即便你对这些很熟悉了，还是有必要看看这些是如何扩展到lambda上使用的。
    Predicate接口 (断言型接口，判断)
        Predicate 接口只有一个参数，返回boolean类型。该接口包含多种默认方法来将Predicate组合成其他复杂的逻辑（比如：与，或，非）
            Boolean test(T t);
    Function 接口 (函数型接口)
        Function 接口有一个参数并且返回一个结果，并附带了一些可以和其他函数组合的默认方法（compose, andThen）
            R apply(T t);
    Supplier 接口(供给型接口)
        Supplier 接口返回一个任意范型的值，和Function接口不同的是该接口没有任何参数
            T get();
    Consumer 接口(消费型接口)
        Consumer 接口表示执行在单个参数上的操作。
            void accept(T t);
    Comparator 接口
        Comparator 是老Java中的经典接口， Java 8在此之上添加了多种默认方法：
            compare、reversed...
    Optional 接口
        Optional 不是函数是接口，这是个用来防止NullPointerException异常的辅助类型
        常用方法:
            Optional.of(T t): 创建一个Optional 实例
            Optional.empty(): 创建一个空的Optional 实例
            Optional.ofNullable(T t): 如果t不为空则创建一个不为空的实例，如果T为空，则创建一个为空的实例
            Optional.isPresent: 判断是否包含空值
            orElse(T t): 如果调用对象包含值，返回该值，否则返回T
            orElseGet(Supplier s): 如果调用对象包含值，返回该值，否则返回s获取的值
            map(Function f): 如果有值对其处理，并返回处理后的Optional,否则返回Optional.empty()
            flatMap(Funtion mapper)

    Stream 接口 (Java8 核心特性)(并不存储数据，不会改变原有对象，返回持有结果的新Stream，Stream是"延迟执行"的，等待需要结果才执行)
        java.util.Stream 表示能应用在一组元素上一次执行的操作序列。
        Stream 操作分为中间操作或者最终操作两种，最终操作返回一特定类型的计算结果，而中间操作返回Stream本身，
        这样你就可以将多个操作依次串起来。 Stream 的创建需要指定一个数据源，
        比如 java.util.Collection的子类，List或者Set， Map不支持。Stream的操作可以串行执行或者并行执行。

        Stream的操作:
            创建Stream
                1.通过Collection系列接口提供的 stream、paraleStream方法创建
                2.通过Arrays中的stream方法获取数组流
                3.Stream类中的of静态方法
                4.创建无限流(Stream.iterate Stream.generate)

            中间操作

                map      接收lambda参数，将元素转换成其它形式或提取信息，接收一个函数作为参数，该函数被应用到每个元素上，并将其映射为一个新元素
                flatMap  多维数组扁平化，接收一个函数作为参数，将流的每一个值换成另一个流，再把所有流凑成一个新流

                filter   过滤流，接收lambda函数，使其按表达式过滤某些数据
                limit    截断流，使其不超过n条数据,取n条数据
                skip     跳过元素，返回一个跳过前n个元素的流，若流不大于n，则返回空
                distinct 通过流的 hashcode 和 equals 方法去重

                sorted  --自然排序
                sorted(Comparator com) --定制排序
            终止Stream
                allMatch    检查是否包含所有元素
                anyMatch    检查是否至少包含一个元素
                noneMatch   检查是否没有匹配所有元素
                findFrist   返回第一个元素
                findAny     返回流中任意元素
                count       返回流中的总个数
                max         返回流中的最大值
                min         返回流中的最小值

                reduce(T identity,BinaryOperator)/reduce(BinaryOperator)  规约，将流中的元素反复结合起来，返回一个新值
                    例:
                        List<Integer> numList = Arrays.asList(1,2,3,4,5,6,7,8,9);
                        Integer sum = numList.stream().reduce(0,(x,y) -> x+y);
                        System.out.println(sum);
                    例:
                        List<Person> personList = new ArrayList<Person>(){
                            {
                                put(new Person("lili",25));
                                put(new Person("hsy",24));
                                put(new Person("kenny",24));
                            }
                        };
                        personList.stream()
                            .map(Person::getAge()) //返回age集合Steam流
                            .reduce(Integer::sum); //返回age集合sum值
                collect 收集( Collectors收集工具类(静态方法提供常用收集器) )
                    分组(groupingBy)
                        Map<String,List<Person>> map = personList.stream().collect(Collectors.groupingBy((e)->{
                            if(e.getAge()<=35){
                                return "青年";
                            }else if(e.getAge()<=50){
                                return "中年";
                            }else{
                                return "老年";
                            }
                        }));
                    分区:(partitioningBy)(大于35的一个区，小于等于35的一个区域)
                        Map<Boolean,List<Person>> map = personList.stream().collect(Collects.partitioningBy((e)->{
                            e.getAge()>35
                        }));
                    拼接:(joining)
                        String names = personList.stream().map(Person::getName).collect(Collects.joining(,));

    Sort 排序
        排序是一个中间操作，返回的是排序好后的Stream。如果你不指定一个自定义的Comparator则会使用默认排序。
    Match 匹配
        提供了多种匹配操作，允许检测指定的Predicate是否匹配整个。所有的匹配操作都是最终操作，并返回一个boolean类型的值。
    Count 计数
        计数是一个最终操作，返回Stream中元素的个数，返回值类型是long。
        例:long startsWithB =
              stringCollection
                  .stream()
                  .filter((s) -> s.startsWith("b"))
                  .count();
          System.out.println(startsWithB);    // 3
    Reduce 规约
        允许通过指定的函数来讲stream中的多个元素规约为一个元素，规越后的结果是通过Optional接口表示的：
        例:Optional<String> reduced =
              stringCollection
                  .stream()
                  .sorted()
                  .reduce((s1, s2) -> s1 + "#" + s2);
          reduced.ifPresent(System.out::println);

9. Date API
    Clock 时钟
        Clock类提供了访问当前日期和时间的方法，Clock是时区敏感的，可以用来取代 System.currentTimeMillis() 来获取当前的微秒数。
        某一个特定的时间点也可以使用Instant类来表示，Instant类也可以用来创建老的java.util.Date对象。
        例:
            Clock clock = Clock.systemDefaultZone();
            long millis = clock.millis();
            Instant instant = clock.instant();
            Date legacyDate = Date.from(instant);   // legacy java.util.Date

    Timezones 时区
        在新API中时区使用ZoneId来表示。时区可以很方便的使用静态方法of来获取到。 时区定义了到UTS时间的时间差，
        在Instant时间点对象到本地日期对象之间转换的时候是极其重要的。
        例:
            ZoneId zone1 = ZoneId.of("Europe/Berlin");
    LocalTime 本地时间

    LocalDate 本地日期

    LocalDateTime 本地日期时间
    
    Oracle 官方介绍: 
        https://www.oracle.com/technical-resources/articles/java/jf14-date-time.html
    博客参考: https://programminghints.com/2017/05/still-using-java-util-date-dont/
10. 注解
    允许我们把同一个类型的注解使用多次，只需要给该注解标注一下@Repeatable即可。

Fork/Join
    Task - fork(分配成多个小任务) - 并行求值 - join(多次合并结果)

Spliterator(可分割迭代器)(多线程并行迭代的迭代器)
    主要作用就是把集合分成了好几段，每个线程执行一段，因此是线程安全的。基于这个原理，以及modCount的快速失败机制，如果迭代过程中集合元素被修改，会抛出异常。
    https://www.cnblogs.com/nevermorewang/p/9368431.html
