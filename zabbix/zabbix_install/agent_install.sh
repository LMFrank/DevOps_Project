#!/bin/bash

# 检查 Zabbix 仓库是否已安装
if ! rpm -q zabbix-release >/dev/null 2>&1; then
    echo "Zabbix 仓库尚未安装，开始安装..."
    rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm || { echo "安装 Zabbix 仓库失败"; exit 1; }
else
    echo "Zabbix 仓库已安装，跳过安装步骤。"
fi

# 以下步骤保持不变...
# 清理 yum 缓存
echo "清理 yum 缓存..."
yum clean all || { echo "清理 yum 缓存失败"; exit 1; }

# 安装 Zabbix 代理
echo "安装 Zabbix 代理..."
yum install -y zabbix-agent || { echo "安装 Zabbix 代理失败"; exit 1; }

# 启动并启用 Zabbix 代理服务
echo "启动并启用 Zabbix 代理服务..."
systemctl start zabbix-agent || { echo "启动 Zabbix 代理服务失败"; exit 1; }
systemctl enable zabbix-agent || { echo "设置 Zabbix 代理服务自启动失败"; exit 1; }

# 检查服务状态
echo "检查 Zabbix 代理服务状态..."
systemctl is-active --quiet zabbix-agent && echo "Zabbix 代理服务正在运行。" || echo "Zabbix 代理服务未运行。"

# 检测服务器内网 IP 地址
echo "检测服务器内网 IP 地址..."
INTERNAL_IP=$(hostname -I | awk '{print $1}') || { echo "无法检测到内网 IP 地址"; exit 1; }

# 定义 Zabbix 服务器的内网 IP
ZABBIX_SERVER_IP="172.16.2.138" # 请替换成实际的 Zabbix 服务器内网 IP

# 配置 Zabbix 代理
echo "配置 Zabbix 代理..."
CONFIG_FILE="/etc/zabbix/zabbix_agentd.conf"
sed -i "s/^Server=.*/Server=${ZABBIX_SERVER_IP}/" "$CONFIG_FILE" || { echo "配置 Server 失败"; exit 1; }
sed -i "s/^ServerActive=.*/ServerActive=${ZABBIX_SERVER_IP}/" "$CONFIG_FILE" || { echo "配置 ServerActive 失败"; exit 1; }
sed -i "s/^Hostname=.*/Hostname=${INTERNAL_IP}/" "$CONFIG_FILE" || { echo "配置 Hostname 失败"; exit 1; }

systemctl restart zabbix-agent || { echo "启动 Zabbix 代理服务失败"; exit 1; }

echo "Zabbix 代理已部署在 $INTERNAL_IP"