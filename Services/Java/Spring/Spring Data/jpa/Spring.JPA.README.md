## Spring JPA
1. 启动注册: JpaRepositoriesRegistrar
    1. 接口父类: AbstractRepositoryConfigurationSourceSupport
    2. 接口实现: ImportBeanDefinitionRegistrar 
2. 委托类: RepositoryConfigurationDelegate
    1. JpaRepositoryConfigExtension#registerBeansForRoot
        1. 准备工作 (初始化工具对象)
            1. entityManager 注册
            2. 初始化 FragmentMetadata 
                1. 初始化 CachingMetadataReaderFactory 元数据读取工厂
            3. 初始化 CustomRepositoryImplementationDetector 自定义实现类扫描的处理逻辑
        2. 扫描获取 Repository
            1. JpaRepositoryConfigExtension#getRepositoryConfigurations
                1. 参数为：AutoConfiguredAnnotationRepositoryConfigurationSource
                2. 通过 AnnotationRepositoryConfigurationSource#getCandidates 扫类
                3. 获取 Repository 接口类
                ```
                RepositoryConfiguration<T> configuration = getRepositoryConfiguration(candidate, configSource);
                Class<?> repositoryInterface = loadRepositoryInterface(configuration,
                getConfigurationInspectionClassLoader(loader));

                if (repositoryInterface == null) {
                    result.add(configuration);
                    ontinue;
                }
                RepositoryMetadata metadata = AbstractRepositoryMetadata.getMetadata(repositoryInterface);
                ```