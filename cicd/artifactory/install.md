### 1. 准备工作
- **确保 Docker 版本**：使用 Docker 20.10.10 及以上版本。

### 2. 下载 Artifactory 镜像
以 7.71.11 版本为例，运行以下命令下载镜像：
```bash
docker pull releases-docker.jfrog.io/jfrog/artifactory-pro:7.71.11
```

### 3. 创建安装目录
以 `/root/jfrog/` 为例，运行以下命令创建目录并设置权限：
```bash
mkdir /root/jfrog
mkdir -p /root/jfrog/artifactory/var/etc/
touch /root/jfrog/artifactory/var/etc/system.yaml
chown -R 1030:1030 /root/jfrog/artifactory/var
```

### 4. 配置数据库（可选）
1. PostgreSQL 配置
   如当前没有数据库，通过如下语句创建：
```postgresql
CREATE USER artifactory WITH PASSWORD 'password';
CREATE DATABASE artifactory WITH OWNER=artifactory ENCODING='UTF8';
GRANT ALL PRIVILEGES ON DATABASE artifactory TO artifactory;
Copy
```

修改数据库配置：
编辑配置文件 /root/jfrog/artifactory/var/etc/system.yaml, 添加 database 部分，完整示例如下:
```yaml
configVersion: 1
shared:
database:
type: postgresql
driver: org.postgresql.Driver
url: jdbc:postgresql://localhost:5432/artifactory
username: artifactory
password: password
```

### 5. 配置存储（可选）
如果需要配置本地存储，按照以下步骤操作：
1. **创建存储目录**：
   ```bash
   mkdir -p /root/jfrog/artifactory/var/etc/artifactory/
   touch /root/jfrog/artifactory/var/etc/artifactory/binarystore.xml
   chown -R 1030:1030 /root/jfrog/artifactory/var
   ```
2. **编辑存储配置文件**：
   编辑 `/root/jfrog/artifactory/var/etc/artifactory/binarystore.xml`，添加以下内容：
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <config version="1">
       <chain template="file-system"/>
       <provider id="file-system" type="file-system">
           <fileStoreDir>/var/opt/jfrog/artifactory/data/artifactory/filestore</fileStoreDir>
       </provider>
   </config>
   ```
   **注意**：如果自定义存储路径，需要使用 `-v` 参数挂载并授权。

### 6. 安装并启动 Artifactory
运行以下命令启动 Artifactory 容器：
```bash
docker run --name artifactory \
-v /root/jfrog/artifactory/var/:/var/opt/jfrog/artifactory \
-d -p 8081:8081 -p 8082:8082 \
releases-docker.jfrog.io/jfrog/artifactory-pro:7.71.11
```

### 7. 检查日志
运行以下命令查看日志，确认启动成功：
```bash
docker logs -f artifactory
```
如果看到以下输出，则表示启动成功：
```
###############################################################
###    All services started successfully in 50.958 seconds    ###
###############################################################
```

### 8. 访问 Artifactory
通过浏览器访问以下地址：
```
http://192.168.56.13:8082
```
默认用户名和密码为 `admin/password`。

参考：https://www.jfrogchina.com/docs/docker-install-artifactory-1/

