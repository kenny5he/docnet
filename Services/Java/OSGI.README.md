## [OSGI](https://blog.csdn.net/luoww1/article/details/9703417)
1. OSGI是什么？
    1. OSGI全称是Open Services Gateway Initiative，它是JAVA动态模块系统。
2. OSGI能干什么？
   
3. OSGI 常见案例:
    1. 案例: NettyBundleActivator
        - MANIFEST.MF
            - Bundle-ManifestVersion: 2 (1代表OSGI规范第三版,2代表OSGI规范第四版)
            - Bundle-SymbolicName: org.jboss.netty
            - Bundle-Activator: org.jboss.netty.container.osgi.NettyBundleActivator