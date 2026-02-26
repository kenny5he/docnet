# Spring Boot Tomcat 

## Spring Boot Tomcat 常见问题配置
1. 文件头过大
```properties
# 请求参数长度
server.tomcat.max-http-form-post-size=10MB
server.max-http-header-size=10MB
```

2. 上传文件过大
```properties
# 最大上传文件大小(10MB)
spring.servlet.multipart.max-file-size=10485760
spring.servlet.multipart.max-request-size=10485760

```