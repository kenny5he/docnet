## Spring Security Outh2 官方文档
https://projects.spring.io/spring-security-oauth/docs/oauth2.html

### Spring Security 
#### Configuration
1. WebSecurityConfigurerAdapter
    1. 作用: 主要是为了方便用户对Web Security 安全配置通过覆写其方法configure 方法对AuthenticationManagerBuilder，WebSecurity，HttpSecurity进行定制、个性化配置,
    2. 扩展延伸知识
        1. HttpSecurity
            - authorizeRequests(): 配置路径拦截，表明路径访问所对应的权限，角色，认证信息。
            - formLogin(): 对应表单认证相关的配置
            - logout(): 对应了注销相关的配置
            - httpBasic(): 可以配置basic登录
            - etc: 
         2. WebSecurity
            - httpFirewall(HttpFirewall firewall): 防火墙配置
            - addSecurityFilterChainBuilder(): 配置安全过滤器的构造器
            - securityInterceptor(): 设置SecurityInterceptor 设置安全拦截器
        3. AuthenticationManager
            - authenticationEventPublisher(): 设定事件通知器
            - authenticationProvider(): 
            - jdbcAuthentication()/ldapAuthentication()/内存认证器 
    3. Example
        1. 对HttpSecurity进行定制化配置
            ```
                @Override
                protected void configure(HttpSecurity http) throws Exception {
                    http
                       .authorizeRequests()
                           .antMatchers("/", "/home").permitAll()
                           .anyRequest().authenticated()
                           .and()
                       .formLogin()
                           .loginPage("/login")
                           .permitAll()
                           .and()
                       .logout()
                           .permitAll();
            ```
        2. 对WebSecurity进行定制化配置
           ```
               @Override
               public void configure(WebSecurity web) throws Exception {
                   web
                       .ignoring()
                       .antMatchers("/resources/**");
               }
           ```
        3. 对AuthenticationManager的建造器 进行定制化配置
            1. 全局性生效配置
                ```
                    @Autowired
                    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
                        auth
                            .inMemoryAuthentication()
                            .withUser("admin").password("admin").roles("USER");
                    }
                ```
            2. 作用特定范围的 WebSecurityConfigurerAdapter配置
                ```
                    @Override
                    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
                        auth
                            .inMemoryAuthentication()
                            .withUser("admin").password("admin").roles("USER");
                    }
                ```
2. AuthorizationServerConfigurerAdapter
    1. 作用: 主要是为了方便用户对认证模块的定制化配置，通过configure对AuthorizationServerSecurityConfigurer、ClientDetailsServiceConfigurer、AuthorizationServerEndpointsConfigurer进行定制化配置
    2. 扩展延伸知识
        1. AuthorizationServerSecurityConfigurer
           
        2. ClientDetailsServiceConfigurer
           
        3. AuthorizationServerEndpointsConfigurer
            
    3. Example

#### User Info
1. UserDetailsService
    
2. org.springframework.security.core.userdetails.User
    
#### Logout
1. SecurityContextLogoutHandler
    
2. LogoutSuccessHandler
    
### Spring Security Oauth2 
#### Token
1. TokenEnhancer

2. ResourceServerConfigurerAdapter

3. AuthorizationServerSecurityConfiguration

4. AuthorizationServerEndpointsConfiguration

5. AuthorizationServerEndpointsConfigurer
### DB Store 
##### JDBC 
参考Blog: https://blog.csdn.net/u013938484/article/details/106238189
1. JdbcClientDetailsService(oauth_client_details)
2. JdbcClientTokenServices(oauth_client_token)
3. JdbcTokenStore(oauth_access_token/oauth_refresh_token)
4. JdbcAuthorizationCodeServices(oauth_code)

#### Redis
1. import org.springframework.security.oauth2.provider.token.store.redis.StandardStringSerializationStrategy;

### Spring Security Cas
1. 配置初始化 Cas 账号后加载用户信息，并且加载用户权限信息
    - 源码: SpringSecurityAssertionAutoConfiguration 
    ```
        @Bean
        @ConditionalOnMissingBean(name = "springSecurityCasUserDetailsService")
        public AuthenticationUserDetailsService<CasAssertionAuthenticationToken> springSecurityCasUserDetailsService() {
            return new GrantedAuthorityFromAssertionAttributesUserDetailsService(
                configProps.getAttributeAuthorities().toArray(new String[]{}));
        }
    ```
2. CasClientConfigurer

#### Cas 过滤器: 
1. AuthenticationFilter: 主要保证跳转到登录页面,(Filter Order 2)
2. SpringSecurityAssertionSessionContextFilter: (Filter Order 0)
    1. 从Session的属性(_const_cas_assertion_)中获取Assertion信息，再通过CasAssertionAuthenticationToken构造凭证信息。
    2. 通过userDetailsService.loadUserDetails加载用户信息
    3. 在构造CasAuthenticationToken，并塞入到SecurityContextHolder中
3. Cas30ProxyReceivingTicketValidationFilter/Cas20ProxyReceivingTicketValidationFilter/ (Filter Order 1)
    1. 作用：
        1. 在登录系统，完成登录后，登录系统将跳转到业务系统，并携带一个Token链接凭证，例: https://microservice.microfoolish.com:1443/framework/demo/?ticket=ST-11-oTXDi-rbzDAj3EWnJs0rzliMKss-apayedeMacBook-Pro,
        2. CAS 的AbstractCasFilter.retrieveTicketFromRequest 通过我们配置协议方式，从参数中获取ticket值
        3. AbstractTicketValidationFilter 将ticket值获取到后，再通过我们协议设定对应的(Cas20ServiceTicketValidator/Saml11TicketValidator)去验证ticket值的正确性
        4. AbstractUrlBasedTicketValidator.validate 校验调用 登录系统服务端请求验证业务系统地址、业务系统Ticket信息 (AbstractCasProtocolUrlBasedTicketValidator.retrieveResponseFromServer)
        5. 验证之后解析结果(Cas20ServiceTicketValidator.parseResponseFromServer) 返回 Assertion信息
        6. 验证通过之后 就将 Assertion信息 存储在Session属性中(_const_cas_assertion_)(参考SpringSecurityAssertionSessionContextFilter从Session中读取该数据)
