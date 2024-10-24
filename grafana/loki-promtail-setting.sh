#!/bin/bash

Version=3.0.0

wget https://github.com/grafana/loki/releases/download/v${Version}/loki-linux-amd64.zip
wget https://github.com/grafana/loki/releases/download/v${Version}/promtail-linux-amd64.zip

wget https://raw.githubusercontent.com/grafana/loki/v${Version}/cmd/loki/loki-local-config.yaml
wget https://raw.githubusercontent.com/grafana/loki/v${Version}/clients/cmd/promtail/promtail-local-config.yaml

unzip loki-linux-amd64.zip && unzip promtail-linux-amd64.zip
sudo chmod a+x loki-linux-amd64 && sudo chmod a+x promtail-linux-amd64
sudo mv loki-linux-amd64 /usr/local/bin/loki && sudo mv promtail-linux-amd64 /usr/local/bin/promtail
rm loki-linux-amd64.zip && rm promtail-linux-amd64.zip

sudo mkdir -p /etc/loki/logs && sudo mkdir -p /etc/promtail/logs
sudo mv loki-local-config.yaml /etc/loki/ && sudo mv promtail-local-config.yaml /etc/promtail/

cat << "EOF" > loki.service
[Unit]
Description=Loki service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/loki -config.file /etc/loki/loki-local-config.yaml
Restart=on-failure
RestartSec=20
StandardOutput=append:/etc/loki/logs/loki.log
StandardError=append:/etc/loki/logs/loki.log

[Install]
WantedBy=multi-user.target
EOF

cat << "EOF" > promtail.service
[Unit]
Description=Promtail service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/promtail -config.file /etc/promtail/promtail-local-config.yaml
Restart=on-failure
RestartSec=20
StandardOutput=append:/etc/promtail/logs/promtail.log
StandardError=append:/etc/promtail/logs/promtail.log

[Install]
WantedBy=multi-user.target
EOF

sudo mv loki.service /etc/systemd/system/ && sudo mv promtail.service /etc/systemd/system/
sudo systemctl daemon-reload && sudo systemctl start loki.service && sudo systemctl start promtail.service