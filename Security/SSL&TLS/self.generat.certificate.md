## 自签证书
### keytool
    1. 使用keytool生成证书
        注:
            CN=common Name
            OU=organization Unit
            O=organization Name
            L=locality Name
            ST=state Name
            C=country
    2. 将jks格式的证书转成cer格式
        ```
        keytool -export -alias apaye -file apaye.cer -keystore apaye.jks -storepass apaye.adm1n
        ```
    3. 导入证书到keystore：
        1. 导入信任的CA分证书到keystore
            ```
            keytool -import -v trustcacerts -alias ca -file ca.crt -keystore my_keystore
            ```
        2. 导入签名后的server证书到keystore
            ```            
            keytool -import -v trustcacerts -alias server -file server.crt -keystore my_keystore
            ```
    4. 导入证书至jvm
        ```
        keytool -import -trustcacerts -alias apaye -keystore "%JAVA_HOME%/jre/lib/security/cacerts " -file /path/mycerts.cer -storepass apaye.adm1n
        ```
### openssl
1. OpenSSL 
   ```
     openssl req -new -x509 -keyout ca.key -out ca.crt
   ```