###Lombok
官方文档: https://projectlombok.org/features/all
1. 作用: 提高代码整洁度
2. 项目依赖、插件安装:
    1. Maven
        1. 依赖
            ```
                <dependency>
                    <groupId>org.projectlombok</groupId>
                    <artifactId>lombok</artifactId>
                    <version>1.18.2</version>
                </dependency>
            ```
        2. maven编译插件
            ```
                <build>
                  <plugins>
                      <plugin>
                          <groupId>org.projectlombok</groupId>
                          <artifactId>lombok-maven-plugin</artifactId>
                          <version>1.16.6.1</version>
                      </plugin>
                  </plugins>
                </build>
           ```
    2. Eclipse插件
        1. [下载lombok jar](https://projectlombok.org/download)
        2. 运行下载的lombok jar
        3. 关闭弹出的警告窗口，点击 Specify location..
        4. 选择eclipse的安装目录
        5. 点击Install / Update
        6. 点击Quit Installer，完成安装
        7. 验证安装
            - 确认eclipse安装路径下是否多了一个lombok.jar包，并且其配置文件eclipse.ini中是否 添加了如下内容:-javaagent:D:\build-env\eclipse\lombok.jar
        8. 重启Eclipse
    2.3 [IDEA插件](http://plugins.jetbrains.com/plugin/6317-lombok-plugin)

3. 使用:
    1. @Getter/@Setter 自动生成get set方法
        ```
        public Class Person{
            private String nikename;

            @Getter
            @Setter
            private Integer age;

            @Setter(AccessLevel.PUBLIC)
            @Getter(AccessLevel.PROTECTED)
            private String sex;

            private void setNikename(String nikename){
                this.nikename = nikename;
            }

            private String getNikename(){
                return nikename;
            }
        }
        ```
    2. @NonNull
        - Old:
            ```
            public String getName(@NonNull Person p){
                if(p==null){
                    throw new NullPointerException("person");
                }
                return p.getName();
            }
            ```
        - New:
            ```
            public String getName(@NonNull Person p){
                return p.getName();
            }
          
            ```
    3. @Cleanup
        - Old:
            ```
            InputStream in = new FileInputStream(args[0]);
            try {
              OutputStream out = new FileOutputStream(args[1]);
              try {
                byte[] b = new byte[10000];
                while (true) {
                  int r = in.read(b);
                  if (r == -1) break;
                  out.write(b, 0, r);
                }
              } finally {
                if (out != null) {
                  out.close();
                }
              }
            } finally {
              if (in != null) {
                in.close();
              }
            }
            ```
        - New:
            ```
            @Cleanup InputStream in = new FileInputStream(args[0]);
            @Cleanup OutputStream out = new FileOutputStream(args[1]);
            byte[] b = new byte[1024];
            while (true) {
               int r = in.read(b);
               if (r == -1) break;
               out.write(b, 0, r);
            }
            ```
    4. @ToString
        - Old:
            ```
            public class Student{
                private Integer card;
                private String name;
                private String subject;
                private String score;
                private String ranking;

                private String toString(){
                    return "Application{" +
                            "card='" + card + '\'' +
                            ", name='" + name + '\'' +
                            ", subject='" + subject + '\'' +
                            ", score='" + score + '\'' +
                            '}';
                }
            }
            ```
        - New:
            ```
            @ToString
            public class Student{
                private Integer card;
                private String name;
                private String subject;
                private String score;
                @ToString.Exclude private String ranking;//排除属性toString
            }
            //@ToString(callSuper=true, includeFieldNames=true)  父类属性一并toString(默认skip),并显示字段名称(默认显示字段名称)
            ```
        
    5. @EqualsAndHashCode(callSuper=true)
            Equals
            Hashcode

    6. @NoArgsConstructor/@RequiredArgsConstructor/@AllArgsConstructor
        - @NoArgsConstructor 生成无参构造方法
        - @RequiredArgsConstructor 带有@NonNull注解的或者带有final修饰的成员变量生成对应的构造方法
        - @AllArgsConstructor 生成带所有字段的构造方法
        1. 方式对比
        - Old:
            ```
            public class Student{
                private Integer card;
                private String name;
                private String subject;
                private String score;
                private String ranking;

                public Student(){}

                public static Student getInstance(Integer card,String name,String subject,String score){
                    return new Student(card, name, subject, score);
                }

                public Student(Integer card,String name,String subject,String score ){
                    this.card = card;
                    this.name = name;
                    this.subject = subject;
                    this.score = score;
                }

                public Student(Integer card,String name,String subject,String score,String ranking){
                    this.card = card;
                    this.name = name;
                    this.subject = subject;
                    this.score = score;
                    this.ranking = ranking;
                }
            }
            ```
        - New:
            ```
            @NoArgsConstructor
            @RequiredArgsConstructor(staticName = "getInstance")
            @AllArgsConstructor
            public class Student{
                @NotNull
                private Integer card;

                @NotNull
                private String name;

                @NotNull
                private String subject;

                @NotNull
                private String score;

                private String ranking;

            }
            ```
    7. @Data/@Value
        - @Data 用于POJO
            就像具有隐式@Getter，@Setter，@ToString，@EqualsAndHashCode和@RequiredArgsConstructor在类注解
            （不同之处在于没有构造将生成如果已经存在任何明确写入构造函数）
        - @Value 对于具有泛型的类
            @ToString，@EqualsAndHashCode，@AllArgsConstructor，@FieldDefaults，和@Getter

    8. @SneakyThrows
        - Old:
            ```
            public class xxxMessage{
              @SneakyThrows(UnsupportedEncodingException.class)
              public String utf8ToString(Message msg) {
                return new String(msg.getBody(), "UTF-8");
              }
            }
            ```
        - New:
            ```
            public class xxxMessage {
              public String utf8ToString(Message msg) {
                try {
                  return new String(msg.getBody(), "UTF-8");
                } catch (UnsupportedEncodingException e) {
                  throw Lombok.sneakyThrow(e);
                }
              }
            }
            ```
    9. @Synchronized
        - Old:
            ```
            public class Synchronized {
               private static final Object $LOCK = new Object[0];
               private final Object $lock = new Object[0];
               private final Object readLock = new Object();

               public static void hello() {
                 synchronized($LOCK) {
                   System.out.println("world");
                 }
               }

               public int answerToLife() {
                 synchronized($lock) {
                   return 42;
                 }
               }

               public void foo() {
                 synchronized(readLock) {
                   System.out.println("bar");
                 }
               }
            }
            ```
        - New:
            ```
            public class Synchronized {
                private final Object readLock = new Object();

                @Synchronized
                public static void hello() {
                    System.out.println("world");
                }

                @Synchronized
                public int answerToLife() {
                    return 42;
                }

                @Synchronized("readLock")
                public void foo() {
                    System.out.println("bar");
                }
            }
            ```
    10. @Log
        - Old:
            ```
                private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(LogExampleOther.class);
            ```
        - New:
            ```
                @Log
                public class xxxService implement IxxxService{
    
                    public void method(){
                        log.info("log");
                    }
                }
    
                @Slf4j
                public class xxxService implement IxxxService{
    
                    public void method(){
                        log.info("log");
                    }
                }
    
                @CommonsLog
                public class xxxService implement IxxxService{
    
                    public void method(){
                        log.info("log");
                    }
                }
            ```