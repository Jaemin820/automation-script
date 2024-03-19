#!/bin/bash

# This script is used to upgrade the Prometheus version
set -e

# Function to handle errors
error_handling() {
  exit_status=$?
  if [ $exit_status -ne 0 ]; then
    echo "\033[31mAn error occurred. Prometheus installation failed.\033[0m\n"
  fi
  exit $exit_status
}

# Trap the error
trap error_handling EXIT

echo "Download the latest version of Prometheus from the following link:" https://prometheus.io/download/

# Ask the user to enter the version of Prometheus
echo "\033[36mEnter the version of Prometheus you want to install (e.g., 2.50.0):\033[0m"
read VERSION

# Download Prometheus version $VERSION and extract the tar file
echo "\033[36mDownloading Prometheus version $VERSION\033[0m\n"
wget https://github.com/prometheus/prometheus/releases/download/v$VERSION/prometheus-$VERSION.linux-amd64.tar.gz
tar -xvf prometheus-$VERSION.linux-amd64.tar.gz

# Remove the tar file
echo "\033[36mRemoving the tar file\033[0m\n"
rm prometheus-$VERSION.linux-amd64.tar.gz

# Move the prometheus binary to /home/ubuntu/nodeinfra-prometheus/prometheus
echo "\033[36mMove the prometheus binary to /home/ubuntu/nodeinfra-prometheus/prometheus\033[0m\n"
mv prometheus-$VERSION.linux-amd64/prometheus /home/ubuntu/nodeinfra-prometheus/prometheus

# Remove the prometheus folder
echo "\033[36mRemoving the prometheus folder\033[0m\n"
rm -rf prometheus-$VERSION.linux-amd64/

# Set the permissions
echo "\033[36mSetting the permissions\033[0m\n"
chmod +x /home/ubuntu/nodeinfra-prometheus/prometheus

# Restart the Prometheus service
echo "\033[36mRestarting the Prometheus service\033[0m\n"
sudo systemctl restart prometheus.service

# Print the success message
echo "\033[32mPrometheus has been installed successfully\033[0m\n"

# Print the version of Prometheus
echo "\033[36mThe version of Prometheus is:\033[0m"
/home/ubuntu/nodeinfra-prometheus/prometheus --version