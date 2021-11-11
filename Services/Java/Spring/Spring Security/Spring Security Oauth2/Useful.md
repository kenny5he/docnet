### OAuth 2.0 授权模式
1. 授权码模式（Authorization Code）
   1. 配置方式
      ```
       @Override
       public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
           clients.inMemory() // <1.1> 内存级配置
                   .withClient("clientapp").secret("112233") // <1.2> Client 账号、密码。
                   .authorizedGrantTypes("authorization_code") // <1.3> 密码模式
                   .scopes("read_userinfo", "read_contacts") // <1.4> 可授权的 Scope
       } 
       ```
   2. 实现类: AuthorizationCodeTokenGranter
2. 密码模式（Resource Owner Password Credentials）
   1. 配置方式
      ```
       @Override
       public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
           clients.inMemory() // <2.1> 内存级配置
                   .withClient("clientapp").secret("112233") // <2.2> Client 账号、密码。
                   .authorizedGrantTypes("password") // <2.3> 密码模式
                   .scopes("read_userinfo", "read_contacts") // <2.4> 可授权的 Scope
      } 
      ```
   2. 实现类: ResourceOwnerPasswordTokenGranter
3. 简化模式（Implicit）
   1. 配置方式
      ```
       @Override
       public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
           clients.inMemory() // <3.1> 内存级配置
                   .withClient("clientapp").secret("112233") // <3.2> Client 账号、密码。
                   .authorizedGrantTypes("implicit") // <3.3> 密码模式
                   .scopes("read_userinfo", "read_contacts") // <3.4> 可授权的 Scope
      } 
      ``` 
   2. 实现类: ImplicitTokenGranter
4. 客户端模式（Client Credentials)
   1. 配置方式
      ```
       @Override
       public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
           clients.inMemory() // <4.1> 内存级配置
                   .withClient("clientapp").secret("112233") // <4.2> Client 账号、密码。
                   .authorizedGrantTypes("client_credentials") // <4.3> 密码模式
                   .scopes("read", "write") // <4.4> 可授权的 Scope
       } 
       ```
   2. 实现类: 
      - ClientCredentialsTokenGranter
      - ClientCredentialsAccessTokenProvider
      - ClientCredentialsResourceDetails
   
5. 扩展新的认证模式
   0: 参考博客: https://blog.csdn.net/a294634473/article/details/109692209
   1. 继承AbstractTokenGranter类
   2. 继承OAuth2AccessTokenSupport并实现 AccessTokenProvider接口
   3. 继承类BaseOAuth2ProtectedResourceDetails
   
6. 加载AuthorizationServerConfigurer/Adapter信息 --> AuthorizationServerSecurityConfiguration



### OAuth2 服务信息
1. Token
   - Path: /oauth/token
   - Code: TokenEndpoint
   - Service: JdbcClientDetailsService
2. CheckToken
   - Path: /oauth/check_token
   - Code: CheckTokenEndpoint
   - 
3. Authorization
   - Path: /oauth/authorize
   - Code: AuthorizationEndpoint
4. 
   
### OAuth2 Configurer --> HttpSecurity
1. OAuth2ClientConfigurer
2. OAuth2ResourceServerConfigurer
3. OAuth2LoginConfigurer