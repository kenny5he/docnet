## @EnableAutoConfiguration (自动配置)
1. 使用场景: @SpringBootApplication 注解
2. Spring.factories 中 org.springframework.boot.autoconfigure.EnableAutoConfiguration

### @EnableAutoConfiguration 原理
1. AutoConfigurationImportSelector
   1. 加载 spring.factories 中的 EnableAutoConfiguration 的配置类
   