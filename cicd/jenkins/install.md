## docker安装jenkins
```shell
docker run \
--name docker-jenkins \
--privileged=true \
--restart=on-failure \
-itd \
-p 8089:8080 \
-p 50000:50000 \
-e TZ='Asia/Shanghai' \
-v jenkins_home:/var/jenkins_home \
-v /etc/localtime:/etc/localtime \
jenkins/jenkins:lts-jdk17

# 获取token
cat /var/jenkins_home/secrets/initialAdminPassword

# 或者使用docker命令行
docker exec -it docker-jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

更改插件源：https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json