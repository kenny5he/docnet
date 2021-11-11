## 软件应用:
1. 信息收集: 
		dmitry: whois查询/子域名收集/端口扫描
		ike-scan	: 收集ipsec vpn server指纹信息
		maltegoce: 域名/账号等关联性收集展示
		netdiscover: 主动发出arp包和截获arp包
		nmap	: 端口服务探测和端口漏洞扫描
		dnmap: 用于组建分布式nmap，dnmap_server为服务端；dnmap_client为客户端
		zenmap: 图形界面版的nmap
		p0f: 监听网卡收发的数据包，从数据包中读取远端机器操作系统服务版本等信息
		regon-ng: 模仿msf的信息侦查框架
		
	系统安全扫描:
		lynis: 系统安全扫描告警
		unix-privesc-check: 审计系统中的关键文件权限是否有异常
		bed: 测试多种服务的缓冲区溢出漏洞的工具
	
	注入检测:
		commix: sqlmap检测sql注入此工具检测系统命令注入
		sqlsus: 用于mysql的盲注检测
		
		
	Web扫描:
		golismero: 类似文本版的awvs(网络漏洞扫描工具)
		nikto: web扫描器
		paros: web爬行和漏扫工具	
		skipfish: 全自动化的web漏洞扫描工具
		w3af: web漏洞扫描框架
		wpscan: 针对wordpress的漏洞扫描工具
		galleta: 用于分析IE的cookie文件输出其中的有用信息
		
	Web代理: 
		burpsuite: web代理截包工具
		
	网站克隆:		
		httrack: 将网站克隆到本地
		
	SQL注入: 	
		sqlmap: sql注入扫描工具
		bbqsql: 高度可配置的交互式的sql盲注工具
		
	数据库猜解:
		sqlinja: 用于猜解ms sql
		
	暴力破解:
		sparta: 图形版的hydra(网络登陆破解工具)，加了端口服务扫描功能
		medusa: 可对IMAP, rlogin, SSH等进行口令猜解，类似hydra
		ncrack: 对IMAP, rlogin, SSH等进行口令猜解，类似hydra	
		
	口令文件制作:
		cewl: 爬取给定的URL并依据限制条件截取网页中的单词生成口令集合
		crunch: 依据限定的条件生成口令集合
		
	Hash码破解:
		hashcat: 多种hash的爆力猜解工具，速度快所耗CPU小（相对）
		john: 用于对系统口令文件的破解（如/etc/passwd）还原出密码明文
		johnny: john的gui版本	
		ophcrack: 基于彩虹表的windows口令破解工具
		
	密码提取:
		mimikatz: 用于从windows内存中提取密码
		
	Wifi破解:
		pyrit: PA/WPA2加密的wifi的密码破解工具	
		aircrack-ng: 针对WEP、 WPA加密方式的wifi密码破解套件
		cowpatty: 基于已捕获握手包和密码字典的WPA-PSK加密的wifi密码的猜解
		Fern WIFI Cracker: 基于字典的WEP和WPA加密的wifi破解工具	
		pixiewps: 针对开启WPS的wifi利用WPS随机数生成中的bug来破解
		reaver: 针对开启WPS的wifi进行暴力破解的工具
		wifite: 较为自动化的wifi破解工具
		
	无线电破解:
		chirp: 各种无线电数据包的拦截工具	
		
	AP:
		Ghost Phiser: 能发现AP并使与AP连接的设备断开连接然后假冒AP让
		kismet: 交互式的AP发现工具，列出周围AP的各种信息
		MDK3: 可向AP发送大量连接、断开请求，可向周围设备告知存在根本不存在的大量AP
	
	IC卡破解:
		mfoc: IC卡密钥破解程序
		mfterm: 交互式IC卡文件写入工具		
		
	逆向工程:
		apktool: 从apk文件中还原出xml和图版等资源文件
		dex2jar: apktool把apk还原成了资源文件和dex，dex2jar把dex还原成jar文件（.class）
		jad: dex2jar把文件还原成了.class，jad进一步把文件还原成.java文件
		flashm: .swf文件的反汇编工具可反汇编出.swf中的脚本代码
		edb-debug: 软件逆向动态调试工具
		
	文件恢复:	
		foremost:文件恢复工具，用于被删除的文件的恢复	
		
	mac欺骗:	
	 macchanger: 修改本机上网时的mac地址，一用作身份隐藏，二可用来绕过wifi mac黑名单	
	
	漏洞利用: 
		armitage	: measploit的gui界面
		beef: 利用msf的exp结合xss构造有攻击性的html页面，当浏览器访问即会受到攻击并获取shell
		metasploit: 就是启动msfconsole 
		msf payload center: 	生成包含exp的windows/android等各平台的可执行文件，木马制作利器,类似于msfvenom
		searchsploit: 用于搜索已从exploitdb下载到本地的漏洞利用脚本	
		Social-Engineering: 用于生成各种插入了exp的文件，诱使目标打开而中招
		termineter: 智能电表攻击框架	
		
		
		
				
		