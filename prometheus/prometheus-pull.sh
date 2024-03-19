#!/bin/bash

# This script pulls the latest changes from the prometheus repository
set -e

# Change to the prometheus directory
cd /home/ubuntu/nodeinfra-prometheus

# Pull the latest changes from the repository
git pull 

sleep 1

# Reload the prometheus configuration
curl -X POST http://localhost:9090/-/reload

sleep 2

# Check the status of the prometheus service
systemctl status prometheus.service