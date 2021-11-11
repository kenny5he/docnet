## Java Beans
1. java.beans.BeanInfo
    - 属性: java.beans.PropertyEditor
    - 方法:
    - 事件:
    - 表达式:
2. java.beans.PropertyEditor
   1. PropertyEditor
   ```
   String text = "name = Kenny";
   PropertyEditor propertyEditor = new StringToPropertiesPropertyEditor();
   // 传递 String 类型的内容
   propertyEditor.setAsText(text);
   ```
   2. PropertyEditorSupport
      - Spring 实现: org.springframework.beans.propertyeditors包目录下
         - org.springframework.beans.propertyeditors.ByteArrayPropertyEditor
         - org.springframework.beans.propertyeditor.ResourceBundleEditor  
         - org.springframework.web.multipart.support.StringMultipartFileEditor
         - org.springframework.http.MediaTypeEditor
         - org.springframework.core.io.ResourceEditor
         - org.springframework.security.core.userdetails.memory.UserAttributeEditor
      - 自定义实现:
      ```
      public class StringToPropertiesPropertyEditor extends PropertyEditorSupport implements PropertyEditor {
      
          // 1. 实现 setAsText(String) 方法
          @Override
          public void setAsText(String text) throws IllegalArgumentException {
              // 2. 将 String 类型转换成 Properties 类型
              Properties properties = new Properties();
              try {
                  properties.load(new StringReader(text));
              } catch (IOException e) {
                  throw new IllegalArgumentException(e);
              }
         
              // 3. 临时存储 Properties 对象
              setValue(properties);
         
              // next 获取临时 Properties 对象 #getValue();
          }
         
          @Override
          public String getAsText() {
              Properties properties = (Properties) getValue();
         
              StringBuilder textBuilder = new StringBuilder();
         
              for (Map.Entry<Object, Object> entry : properties.entrySet()) {
                  textBuilder.append(entry.getKey()).append("=").append(entry.getValue()).append(System.getProperty("line.separator"));
              }
         
              return textBuilder.toString();
          }
       }
      ```
3. java.beans.PropertyDescriptor: JavaBeans 属性描述符
4. java.beans.Introspector: Java内省API(举例: 像X光一样照射JavaBeans内部结构)
5. java.beans.BeanDescriptor: JavaBeans 信息描述符
6. java.beans.MethodDescriptor: JavaBeans 方法描述符
7. java.beans.EventSetDescriptor: JavaBeans 事件集合描述符
   - PropertyChange: PropertyChangeListener 属性值改变
   - vetoableChange: VetoableChangeListener 约束性更改
   
8. java.beans.Introspector: 核心调用类，可以通过此类获取Java BeanInfo
```
   // 参数Object.class 意思是stopClass 找到父类为 Object.class为止。(不包含Object.class)
   BeanInfo beanInfo = Introspector.getBeanInfo(User.class, Object.class);
   PropertyDescriptor[] propertyDescriptories = beanInfo.getPropertyDescriptors();
   
```

## Spring Beans
1. org.springframework.beans.BeanWrapper
    - 属性:
    - 嵌套属性路径:
2. BeanWrapper的使用场景
   - Spring 底层 JavaBeans 基础设施的中心化接口
   - 通常不会直接使用，间接用于 BeanFactory 和 DataBinder
   - 提供标准 JavaBeans 分析和操作，能够单独或批量存储 Java Bean 的属性(properties)
   - 支持嵌套属性路径(nested path)
   - 实现类 org.springframework.beans.BeanWrapperImpl
3. PropertyEditorRegistry
```
public class CustomizedPropertyEditorRegistrar implements PropertyEditorRegistrar {
    @Override
    public void registerCustomEditors(PropertyEditorRegistry registry) {
        // 1. 通用类型转换
        // 2. Java Bean 属性类型转换
        registry.registerCustomEditor(User.class, "context", new StringToPropertiesPropertyEditor());
    }
}
```

4. ConditionalGenericConverter
```
public class PropertiesToStringConverter implements ConditionalGenericConverter {

    @Override
    public boolean matches(TypeDescriptor sourceType, TypeDescriptor targetType) {
        return Properties.class.equals(sourceType.getObjectType())
                && String.class.equals(targetType.getObjectType());
    }

    @Override
    public Set<ConvertiblePair> getConvertibleTypes() {
        return Collections.singleton(new ConvertiblePair(Properties.class, String.class));
    }

    @Override
    public Object convert(Object source, TypeDescriptor sourceType, TypeDescriptor targetType) {

        Properties properties = (Properties) source;

        StringBuilder textBuilder = new StringBuilder();

        for (Map.Entry<Object, Object> entry : properties.entrySet()) {
            textBuilder.append(entry.getKey()).append("=").append(entry.getValue()).append(System.getProperty("line.separator"));
        }

        return textBuilder.toString();
    }
}
```
### 应用实现
1. 将 String 类型的内容转化为目标类型的对象
   1. 实现思路:
      - Spring 框架将文本内容传递到 PropertyEditor 实现的 setAsText(String) 方法
      - PropertyEditor#setAsText(String) 方法实现将 String 类型转化为目标类型的对象
      - 将目标类型的对象传入 PropertyEditor#setValue(Object) 方法
      - PropertyEditor#setValue(Object) 方法实现需要临时存储传入对象
      - Spring 框架将通过 PropertyEditor#getValue() 获取类型转换后的对象
   2. 实现步骤:
      1. 扩展 java.beans.PropertyEditorSupport 类
      2. 实现 org.springframework.beans.PropertyEditorRegistrar
         - 实现 registerCustomEditors(org.springframework.beans.PropertyEditorRegistry) 方法
         - 将 PropertyEditorRegistrar 实现注册为 Spring Bean
      3. 向 org.springframework.beans.PropertyEditorRegistry 注册自定义 PropertyEditor 实现
         - 通用类型实现 registerCustomEditor(Class<?>, PropertyEditor)
         - Java Bean 属性类型实现:registerCustomEditor(Class<?>, String, PropertyEditor)
   