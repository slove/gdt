#!/bin/bash

# 设置服务器IP和端口
SERVER_IP=$1
SERVER_PORT=$2
SERVER_URL="http://$SERVER_IP:5000/data"
INTERVAL=60  # 每60秒发送一次数据

# 安装依赖（如果未安装）
if ! command -v curl &> /dev/null
then
    echo "curl 未安装，正在安装..."
    sudo apt-get update && sudo apt-get install -y curl
fi

# 监控和发送数据
while true
do
    # 获取网络流量
    bytes_sent=$(cat /sys/class/net/eth0/statistics/tx_bytes)
    bytes_recv=$(cat /sys/class/net/eth0/statistics/rx_bytes)

    # 打印调试信息
    echo "Bytes Sent: $bytes_sent"
    echo "Bytes Received: $bytes_recv"
    echo "Sending data to $SERVER_URL"

    # 发送数据到服务器
    curl -X POST -H "Content-Type: application/json" -d "{{\"bytes_sent\": {bytes_sent}, \"bytes_recv\": {bytes_recv}}}" $SERVER_URL

    sleep $INTERVAL
done
