#!/bin/bash

code="+6LjZaDKFGu1vhU/uIHN"
id="e0b98076-4535-4515-aa5f-76223cf1e7c8"
region="ap-northeast-2"
name=$(hostname)

sudo apt install -y awscli

mkdir /tmp/ssm
cd /tmp/ssm

wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl start amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent

output=$(sudo amazon-ssm-agent -y -register -code "$code" -id "$id" -region "$region")
instance_id=$(echo "$output" | grep "Successfully registered" | awk '{print $NF}')

aws ssm add-tags-to-resource --resource-type "ManagedInstance" --resource-id "$instance_id" --tags Key=Name,Value=$name

sudo systemctl restart amazon-ssm-agent

