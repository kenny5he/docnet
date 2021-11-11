# BeanFactory 
1. HierarchicalBeanFactory (层次性的BeanFactory)
    1. 因其层次性特性，HierarchicalBeanFactory 实现类必定存在 parent属性。
    2. HierarchicalBeanFactory 提供两个方法
        - getParentBeanFactory: 获取父类BeanFactory
        - containsLocalBean: 判断当前BeanFactory是否存在Bean?
    3. 代表性子类/接口
        - ApplicationContext
        - DefaultListableBeanFactory

