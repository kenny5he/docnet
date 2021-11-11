## Spring Boot 项目常见错误解决：
1. CXF 与 Spring Boot 版本冲突问题：
    1. error info:
       ```
        2019-04-13 14:45:40.603 ERROR 6628 --- [  restartedMain] o.s.b.web.embedded.tomcat.TomcatStarter  :
        Error starting Tomcat context. Exception: org.springframework.beans.factory.BeanCreationException.
        Message: Error creating bean with name 'org.apache.cxf.spring.boot.autoconfigure.CxfAutoConfiguration':
        Initialization of bean failed;
        nested exception is java.lang.ArrayStoreException: sun.reflect.annotation.TypeNotPresentExceptionProxy
        Caused by: java.lang.ArrayStoreException: sun.reflect.annotation.TypeNotPresentExceptionProxy
        at sun.reflect.annotation.AnnotationParser.parseClassArray(AnnotationParser.java:724) ~[na:1.8.0_144]
        at sun.reflect.annotation.AnnotationParser.parseArray(AnnotationParser.java:531) ~[na:1.8.0_144]
        at sun.reflect.annotation.AnnotationParser.parseMemberValue(AnnotationParser.java:355) ~[na:1.8.0_144]
        at sun.reflect.annotation.AnnotationParser.parseAnnotation2(AnnotationParser.java:286) ~[na:1.8.0_144]
        at sun.reflect.annotation.AnnotationParser.parseAnnotations2(AnnotationParser.java:120) ~[na:1.8.0_144]
        at sun.reflect.annotation.AnnotationParser.parseAnnotations(AnnotationParser.java:72) ~[na:1.8.0_144]
       ``` 
    2. Resolve : CXF 与 SpringBoot 版本不对应导致，类缺失，导致实例化失败
        - 版本对应情况: 
            - SpringBoot 1.xx          ->>  CXF 3.1.12
            - SpringBoot 2.1.3.RELEASE ->>  CXF 3.2.4
      
