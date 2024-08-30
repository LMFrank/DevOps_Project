# 使用官方Go语言的Docker镜像作为基础镜像
FROM golang:1.22.6 AS builder
ENV GO111MODULE on
ENV GOPROXY https://goproxy.cn,direct
# 设置工作目录
WORKDIR /app

# 复制项目中的go.mod和go.sum文件到工作目录
COPY go.mod go.sum ./

# 运行go mod download以下载依赖
RUN go mod download

# 复制项目中的源代码到工作目录
COPY . .

# 构建应用程序
RUN env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /godo .

# 使用轻量级的Alpine Linux镜像作为最终的运行环境
FROM alpine:latest

WORKDIR /root

# 将构建的应用程序复制到最终镜像中
COPY --from=builder /godo .

# 声明运行时需要的端口
EXPOSE 8080

# 运行应用程序
CMD ["./godo"]