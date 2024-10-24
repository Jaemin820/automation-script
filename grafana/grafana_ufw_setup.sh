#!/bin/bash

# Check if the script is run with sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo privileges"
    exit 1
fi

# URL of the Grafana Cloud source IPs
#URL="https://grafana.com/api/hosted-metrics/source-ips"
URL="https://grafana.com/api/hosted-grafana/source-ips"
# URL="https://grafana.com/api/hosted-logs/source-ips"

# Fetch the IP list
IP_LIST=$(curl -s "$URL" | jq -r '.[]')

# Check if curl command was successful
if [ $? -ne 0 ]; then
    echo "Failed to fetch IP list from $URL"
    exit 1
fi

# Loop through each IP and add UFW rule
echo "$IP_LIST" | while read -r ip; do
    # Skip empty lines
    if [ -z "$ip" ]; then
        continue
    fi

    # Add UFW rule
    ufw allow from "$ip"/32 to any port 3100 comment "Grafana_Cloud_loki"

    # Check if UFW command was successful
    if [ $? -eq 0 ]; then
        echo "Added rule for $ip"
    else
        echo "Failed to add rule for $ip"
    fi
done

# Enable UFW if it's not already enabled
ufw status | grep -q "Status: active"
if [ $? -ne 0 ]; then
    echo "Enabling UFW..."
    ufw enable
fi

echo "Finished adding Grafana Cloud IPs to UFW rules"