0. Exception 和 Error的区别？


1. 链式异常(Java 1.4特性)
    - 异常类的父类: Throwable
        1. JVM本身的错误: Error
            1. java虚拟机异常: VirtualMachineError
                - OutOfMemoryError                        内存溢出
                - StackOverflowError                      堆栈溢出错误
                - UnknownError                            未知溢出
            2. 类加载异常: LinkageError

        2. 未预知的错误: Exception
            1. 运行时异常(RuntimeException):
                - IllegalArgumentException                参数校验错误
                - IndexOutOfBoundsException               下标越界
                - NullPointerException                    空指针
                  java.system.infomation.md
            2. 反射操作异常(ReflectiveOperationException)
                - NoSuchMethodException                   方法未找到异常

            3. 输入输出流异常(IOException)
                1. 常见IO流异常:
                    - EOFException                        文件已结束异常
                    - FileNotFoundException               文件未找到异常

            4. 数据库异常(SQLException)

Java 常见的异常类:
    blog: https://www.cnblogs.com/cvst/p/5822373.html