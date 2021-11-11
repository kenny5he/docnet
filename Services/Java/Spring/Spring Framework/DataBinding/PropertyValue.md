### PropertyValues(Interface)
1. 数据主要在 DefaultListableBeanFactory获取getBean的过程中解析 BeanDefinition获取而来
2. 常见实现: 
    - MutablePropertyValues
3. 相关生命周期: InstantiationAwareBeanPostProcessor#postProcessProperties

#### PropertyValue(Class) 
1. 主要用于Bean 解析后，存储解析后的原始数据、及实际数据。
2. 属性/特征
   - name: bean中property的name
   - value: bean中原始值
   - convertValue: 转换后的值