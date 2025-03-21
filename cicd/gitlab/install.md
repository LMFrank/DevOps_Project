## docker安装gitlab
```shell
mkdir config logs data

docker run --name gitlab --detach \
  --hostname gitlab.test.com \
  --publish 443:443 --publish 8070:80 --publish 8022:22 \
  --restart always \
  --volume $PWD/config:/etc/gitlab \
  --volume $PWD/logs:/var/log/gitlab \
  --volume $PWD/data:/var/opt/gitlab \
  --shm-size 256m \
  gitlab/gitlab-ce:17.0.0-ce.0
```