# 安装 Azure Cli
1. 导入 Microsoft 存储库密钥
```shell
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
```
2. 创建本地 azure-cli 存储库信息
```shell
cat > /etc/yum.repos.d/azure-cli.repo <<EOF
[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
```
3. 安装 Azure cli
```shell
yum install azure-cli
```
4. login Azure
```shell
az login
```
5. 