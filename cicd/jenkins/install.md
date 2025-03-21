## docker安装jenkins
### 构建带有maven的jenkins镜像

Dockerfile:
```dockerfile
# 基于官方 Jenkins LTS 镜像，并指定 JDK 17 版本
FROM jenkins/jenkins:lts-jdk17

# 设置时区为亚洲/上海
ENV TZ=Asia/Shanghai

# 设置 Maven 环境变量
ENV MAVEN_HOME=/usr/local/maven/apache-maven-3.9.9
ENV PATH=${MAVEN_HOME}/bin:${PATH}

# 验证 Maven 是否可用（如果挂载成功，这一步会通过）
RUN mvn -version || echo "Maven not available yet. It will be mounted from the host."

# 暴露 Jenkins 默认端口
EXPOSE 8080 50000

# 设置 Jenkins 工作目录卷
VOLUME /var/jenkins_home

# 启动 Jenkins
CMD ["jenkins.sh"]
```

```shell
docker build -t my-jenkins-with-maven:latest .

docker volume create jenkins_home

# docker volume inspect jenkins_home
```

```shell
docker run --name my-jenkins-new --privileged=true --restart=on-failure -itd \
-p 8089:8080 -p 50000:50000 \
-e TZ='Asia/Shanghai' \
-v jenkins_home:/var/jenkins_home \
-v /usr/local/maven/apache-maven-3.9.9:/usr/local/maven/apache-maven-3.9.9 \
my-jenkins-with-maven:latest

# 获取token
cat /var/jenkins_home/secrets/initialAdminPassword

# 或者使用docker命令行
docker exec -it docker-jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

更改插件源：https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json



