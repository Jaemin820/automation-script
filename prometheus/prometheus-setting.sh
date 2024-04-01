#!/bin/bash

VERSION=2.51.0
USERNAME=jaemin820


sudo apt-get install git -y

sudo apt-get install docker.io -y
sudo systemctl start docker
sudo chmod 666 /var/run/docker.sock

git clone https://$USERNAME:$PASSWORD@github.com/nodeinfra/nodeinfra-prometheus.git

wget https://github.com/prometheus/prometheus/releases/download/v$VERSION/prometheus-$VERSION.linux-amd64.tar.gz
tar -xvf prometheus-$VERSION.linux-amd64.tar.gz
rm prometheus-$VERSION.linux-amd64.tar.gz
mv prometheus-$VERSION.linux-amd64/prometheus /home/ubuntu/nodeinfra-prometheus/prometheus
rm -rf prometheus-$VERSION.linux-amd64/
chmod +x /home/ubuntu/nodeinfra-prometheus/prometheus

sudo mkdir -p /data/prometheus
sudo mkdir -p /var/log/prometheus

cat << "EOF" > prometheus.service
[Unit]
Description=Prometheus Server
Documentation=https://prometheus.io/docs/introduction/overview/
After=network-online.target

[Service]
User=root
Restart=on-failure
MemoryHigh=7.5G
LimitNOFILE=10485760

ExecStart=/home/ubuntu/nodeinfra-prometheus/prometheus \
  --config.file=/home/ubuntu/nodeinfra-prometheus/nodeinfra_prometheus.yml \
  --storage.tsdb.path=/data/prometheus \
  --storage.tsdb.retention.time=365d \
  --storage.tsdb.retention.size=950GB \
  --web.console.templates=/home/ubuntu/nodeinfra-prometheus/consoles \
  --web.console.libraries=/home/ubuntu/nodeinfra-prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle \
  --web.enable-admin-api

# Prometheus logging configuration for sending logs to Loki
StandardOutput=file:/var/log/prometheus/error.log
StandardError=file:/var/log/prometheus/prometheus.log

[Install]
WantedBy=multi-user.target
EOF

sudo mv prometheus.service /lib/systemd/system/

sudo systemctl enable prometheus.service
sudo systemctl start prometheus.service
sudo systemctl status prometheus.service