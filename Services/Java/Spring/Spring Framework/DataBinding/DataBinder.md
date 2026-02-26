## DataBinder
DataBinder 是Spring初始化bean 中的一个标准组件。
1. DataBinder 核心组件
   
    |属性|说明|
    |---|---|
    |target|关联目标bean|
    |objectName|目标Bean名称|
    |bindingResult|属性绑定结果|
    |typeConverter|类型转换器|
    |conversionService|类型转换服务|
    |messageCodeResolver|校验错误文案的Code处理器|
    |validators|关联的Bean Validator实例集合|    

2. DataBinder 核心方法
    bind(PropertyValues): 将 PropertyValues Key-Value 内容映射到关联 Bean(target)中的属性上
3. 特性:
    1. 默认支持复合属性。
    2. 默认忽略未知属性。
4. Example:
```
// 0. 创建空白对象
User user = new User();
// 1. 创建 DataBinder
DataBinder binder = new DataBinder(user, "");

// 2. 创建 PropertyValues
Map<String, Object> source = new HashMap<>();
source.put("id", 1);
source.put("name", "Kenny.he");

// 3. PropertyValues
PropertyValues propertyValues = new MutablePropertyValues(source);

// 4. Bind 
binder.bind(propertyValues);

// 5. 获取绑定结果（结果包含错误文案 code，不会抛出异常）
BindingResult result = binder.getBindingResult();
```

#### DataBinder原理
1. PropertyEditorRegistry

2. org.springframework.beans.factory.config.CustomEditorConfigurer


3. TypeConverter
    

4. ConfigurablePropertyAccessor

5. ConversionService (类型转换服务)
    1. canConvert: 是否支持原类型到目标类型的转换，入参: 原始类型、目标类型。
    2. convert: 将source实例转成目标类型，如果转换过程出错，抛出 ConversionException。
    3. DefaultConversionService: 默认实现类

### DataBinder Web组件
- WebDataBinder
- ServletRequestDataBinder
- WebRequestDataBinder
- WebExchangeDataBinder