### Spring Security
#### Spring Security Configuration
1. WebSecurityConfiguration
   1. springSecurityFilterChain 方法构造 FilterChainProxy  
      - webSecurity.build()
      - AbstractConfiguredSecurityBuilder.doBuild 
      - WebSecurity.performBuild 
   2.  
#### Spring Security FilterChainProxy -> Filter 顺序 -100
   1. AbstractSecurityWebApplicationInitializer 将构造的FilterChainProxy注册到Web容器中
#### Spring Security Filter
1. Spring 核心过滤器
    - Spring Security 的Filter 会经过 FilterChainProxy封装，其维护了一个List<SecurityFilterChain>，利用继承Servlet的FilterChain实现的VirtualFilterChain,实现Filter链式调用。
    ```
        Creating filter chain: o.s.s.web.util.matcher.AnyRequestMatcher@1,
        [o.s.s.web.context.SecurityContextPersistenceFilter@8851ce1,
        o.s.s.web.header.HeaderWriterFilter@6a472566, o.s.s.web.csrf.CsrfFilter@61cd1c71,
        o.s.s.web.authentication.logout.LogoutFilter@5e1d03d7,
        o.s.s.web.authentication.UsernamePasswordAuthenticationFilter@122d6c22,
        DefaultLoginPageGeneratingFilter, --> 默认登入页面
        DefaultLogoutPageGeneratingFilter, --> 默认登出页面
        BasicAuthenticationFilter,
        o.s.s.web.savedrequest.RequestCacheAwareFilter@5ef6fd7f,
        o.s.s.web.servletapi.SecurityContextHolderAwareRequestFilter@4beaf6bd,
        o.s.s.web.authentication.AnonymousAuthenticationFilter@6edcad64,
        o.s.s.web.session.SessionManagementFilter@5e65afb6,
        o.s.s.web.access.ExceptionTranslationFilter@5b9396d3,
        o.s.s.web.access.intercept.FilterSecurityInterceptor@3c5dbdf8
    ```
2. SecurityContextPersistenceFilter
    1. 登录过的用户通过Session 获取SecurityContext 上下文, 未获取到Session信息的通过SecurityContextHolder.createEmptyContext() 创建一个空上下文
    2. 上下文从 HttpSessionSecurityContextRepository 通过 SPRING_SECURITY_CONTEXT_KEY 从Session中获取
    3. 将获取到的安全上下文塞入到SecurityContextHolder.setContext(CasAuthenticationToken/UsernamePasswordAuthenticationToken);
3. BasicAuthenticationFilter
    1. Basic Authorization
4. SecurityContextHolderAwareRequestFilter
    1. 
5. SessionManagementFilter

6. FilterSecurityInterceptor
