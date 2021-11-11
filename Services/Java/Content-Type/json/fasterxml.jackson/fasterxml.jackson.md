https://github.com/FasterXML/jackson-annotations/wiki/Jackson-Annotations


## SerializaitonFeature
https://www.dazhuanlan.com/2019/12/27/5e05894aae157/


## Spring Boot jackson
https://www.cnblogs.com/liaojie970/p/9396334.html

### 使用篇
1. 忽略null值序列化
    1. 实体上
       @JsonInclude(Include.NON_NULL)
       //将该标记放在属性上，如果该属性为NULL则不参与序列化
       //如果放在类上边,那对这个类的全部属性起作用
       //Include.Include.ALWAYS 默认
       //Include.NON_DEFAULT 属性为默认值不序列化
       //Include.NON_EMPTY 属性为 空（“”） 或者为 NULL 都不序列化
       //Include.NON_NULL 属性为NULL 不序列化

    2. 代码上
       ObjectMapper mapper = new ObjectMapper();
       mapper.setSerializationInclusion(Include.NON_NULL);  
       //通过该方法对mapper对象进行设置，所有序列化的对象都将按改规则进行系列化
       //Include.Include.ALWAYS 默认
       //Include.NON_DEFAULT 属性为默认值不序列化
       //Include.NON_EMPTY 属性为 空（“”） 或者为 NULL 都不序列化
       //Include.NON_NULL 属性为NULL 不序列化
       User user = new User(1,"",null);
       String outJson = mapper.writeValueAsString(user);
       System.out.println(outJson);
       注意：只对VO起作用，Map List不起作用