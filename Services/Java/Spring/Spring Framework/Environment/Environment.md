### Environment 
1. Environment 接口使用场景
    1. ⽤于属性占位符处理
       1. 3.1 之前版本处理:
           - 组件: org.springframework.beans.factory.config.PropertyPlaceholderConfigurer
           - 接口: org.springframework.util.StringValueResolver
       2. Spring 3.1 + 占位符处理
           - 组件：org.springframework.context.support.PropertySourcesPlaceholderConfigurer
           - 接口: 接口：org.springframework.beans.factory.config.EmbeddedValueResolver
    2. 用于转换 Spring 配置属性类型
    3. 用于存储 Spring 配置属性源（PropertySource）
    4. 用于 Profiles 状态的维护
