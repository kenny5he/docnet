FROM openjdk:11
MAINTAINER docker_user 923662064@qq.com

# 设置时区
RUN echo "Asia/Shanghai" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata \

RUN mkdir -p /app/file/
RUN mkdir -p /app/logs/

# 默认挂载日志目录，临时文件目录
VOLUME ["/app/logs/","/app/file/"]

ADD /${filename}/run.sh /bin/run.sh
RUN chmod +x /*.sh
RUN chmod +x /libs/*.jar

EXPOSE 8003
CMD ["/bin/run.sh"]