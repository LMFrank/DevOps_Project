## docker安装sonarqube

```shell
docker pull sonarqube

docker volume create --name sonarqube_data
docker volume create --name sonarqube_logs
docker volume create --name sonarqube_extensions
docker volume create --name sonarqube_conf

docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 -v sonarqube_data:/opt/sonarqube/data -v sonarqube_extensions:/opt/sonarqube/extensions -v sonarqube_logs:/opt/sonarqube/logs -v sonarqube_conf:/opt/sonarqube/conf sonarqube
```

### 安装plugin
```shell
docker exec sonarqube bash -c 'wget <PLUGIN_JAR_URL> -P "$SONARQUBE_HOME"/extensions/plugins/'

docker restart sonarqube
```

### sonar-scanner-cli
#### docker
```shell
docker run \
    --rm \
    -e SONAR_HOST_URL="<url>" \
    -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=demo" \
    -e SONAR_LOGIN="<token>" \
    -v "<path>" \
    sonarsource/sonar-scanner-cli
```

### 本地安装
```shell
#不一定要和sonarqube装到一个系统下，在哪扫就装哪
 
 
#下载地址
https://docs.sonarsource.com/sonarqube-community-build/analyzing-source-code/scanners/sonarscanner/
 
#解压在 opt 目录
cd /usr/local
unzip sonar-scanner-cli-7.0.2.4839-linux-x64.zip 
 
 
#修改配置文件
cd /usr/local/sonar-scanner-cli-7.0.2.4839-linux-x64/conf
vim sonar-scanner.properties
 
sonar.host.url=<url>
sonar.sourceEncoding=UTF-8
 
 
#在 /etc/profile 的末尾添加环境变量
vim /etc/profile
 
export SONAR_SCANNER_HOME=/usr/local/sonar-scanner-cli-7.0.2.4839-linux-x64
export PATH=$SONAR_SCANNER_HOME/bin:$PATH
 
 
#环境变量立即生效
source /etc/profile
 
#检查一下命令是否可用
sonar-scanner -v
```

```shell
sonar-scanner \
  -Dsonar.projectKey=demo \
  -Dsonar.sources=. \
  -Dsonar.host.url=<url> \
  -Dsonar.token=<token>
```

