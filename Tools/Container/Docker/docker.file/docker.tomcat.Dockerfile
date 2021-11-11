#touch Dockerfile run.sh

FROM ubuntu:14.04
MAINTAINER docker_user hz_13100337320@gmail.com

#设置环境变量，所有操作都是非交互式的
ENV DEBIAN_FRONTEND noninteractive

#设置时区
RUN echo "Asia/Shanghai" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata
	
#安装跟tomcat用户认证相关的软件
RUN apt-get install -yq --no-install-recommends wget pwgen ca-certificates && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
	
#设置tomcat的环境变量
ENV CATALINA_HOME /tomcat
ENV JAVA_HOME /jdk

ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh
RUN chmod +x /tomcat/bin/*.sh

EXPOSE 8080
CMD ["/run.sh"]


#创建tomcat用户和密码文件create_tomcat_admin_user.sh
#!/bin/bash
#if [ -f /.tomcat_admin_created ]; then
#  echo "Tomcat 'admin' user already created"
#  exit 0
#fi
#
##generate password
#PASS=${TOMCAT_PASS:-$(pwgen -s 12 1)}
#_word=$( [ ${TOMCAT_PASS} ] && echo "preset" || echo "random" )
#echo "=> Createing and admin user with a ${_word} password in Tomcat"
#sed -i -r 's/<\/tomcat-users>//' ${CATALINA_HOME}/conf/tomcat-users.xml
#echo '<role rolename="manager-gui"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
#echo '<role rolename="manager-script"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
#echo '<role rolename="manager-jmx"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
#echo '<role rolename="admin-gui"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
#echo '<role rolename="admin-script"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
#echo "<user username=\"admin\"> password=\"${PASS}\" roles=\"manager-gui,manager-script,manager-jmx,admin-gui,admin-script\"/>" >> ${CATALINA_HOME}/conf/tomcat-users.xml
#echo '</tomcat-users>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
#echo "=> Done!"
#touch /.tomcat_admin_created
#echo "========================================================================================="
#echo "You can now configure to this Tomcat server using:"
#echo "admin:${PASS}"
#echo "========================================================================================="


#编写run.sh文件
#!/bin/bash
#if [! -f /.tomcat_admin_created ]; then
#  /create_tomcat_admin_user.sh
#fi
#/user/sbin/sshd -D & exec ${CATALINA_HOME}/bin/catalina.sh run


#构建
#docker build -t tomcat7.0:jdk1.6

#查看日志
#docker logs CONTAINERID
#
#