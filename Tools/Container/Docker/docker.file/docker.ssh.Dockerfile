FROM ubuntu:14.04
MAINTAINER docker_user hz_13100337320@gmail.com

RUN apt-get update

RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/.ssh

#取消pam限制
RUN sed -ri 's/session    required   pam_loginuid.so/#session    required    pam_loginuid.so/g' /etc/pam.d/sshd

#复制配置文件到相应位置，并赋予脚本可执行权限
ADD authorized_keys /root/.ssh/authorized_keys
ADD run.sh /run.sh
RUN chmod 755 /run.sh

#开放端口22
EXPOSE 22

#设置自启动命令
CMD ["/run.sh"]


# 
# 构建本脚本
# docker build -t sshd:dockerfile .
#
# 运行脚本
# docker run -d -p port:22 sshd:dockerfile
#
# 连接服务
# ssh ip -p port