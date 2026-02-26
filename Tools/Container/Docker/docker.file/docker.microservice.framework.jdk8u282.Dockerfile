FROM openjdk:8u282
MAINTAINER docker_user yekun_he@qq.com

# 设置时区
RUN echo "Asia/Shanghai" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata

RUN mkdir -p /app/file/
RUN mkdir -p /app/logs/

# 默认挂载日志目录，临时文件目录
VOLUME ["/app/logs/","/app/file/"]

RUN chmod +x /app/bin/*.sh
RUN chmod +x /app/libs/*.jar

EXPOSE 8003
CMD ["/app/bin/run.sh"]