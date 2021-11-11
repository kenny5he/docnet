## Jackson 实现JAX-RS 规范传入及返回
1. 核心实现
    1. JacksonJsonProvider 通过 JAX-RS规范注解 Provider提供支持，
    2. JacksonJsonProvider 通过SPI的扩展方式对 MessageBodyReader 接口和 MessageBodyWriter 接口从而实现JSON转换
    3. ProviderBase 抽象类完成对 MessageBodyReader 接口和 MessageBodyWriter 接口 是否可读是否可写及写数据的具体实现
    
