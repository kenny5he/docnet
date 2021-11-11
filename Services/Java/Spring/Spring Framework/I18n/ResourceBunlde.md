### ResourceBundle(JDK 默认国际化实现)
1. ResourceBundle
   1. ResourceBundle设计
      1. Key-Value设计
      2. 层次性设计(Parent)
      3. 缓存设计
      4. 字符编码控制(ResourceBundle.Control)
         1. newBundle方法
      5. Control SPI扩展 --> ResourceBundleControlProvider
2. PropertyResourceBundle(Property资源实现)
   1. 
3. ListResourceBundle(列枚举实现)(硬编码方式)
   1. 通过实现 getContents方法，返回一个二维数组(key,value)配置实现
