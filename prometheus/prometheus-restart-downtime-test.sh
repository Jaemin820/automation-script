#!/bin/bash

# Prometheus restart downtime test
URL="localhost:9090"
DT=`date +%H%M%S`
SYSTEMCTL_FILE_NAME=systemctl_restart_result_${DT}.txt
DAEMON_FILE_NAME=daemon_restart_result_${DT}.txt

# Clean up old files
rm systemctl_restart_result_*.txt
rm daemon_restart_result_*.txt

# Start time
startDate=$(date +%T)
# End time
endDate=$(date +%T -d "+3 seconds")

# Restart prometheus.service with systemctl
# sudo systemctl restart prometheus.service
sudo systemctl kill -s HUP prometheus.service
# Check if prometheus.service is up
while [ "$(date +%T)" != "$endDate" ]; 
do 
    curl --silent -o /dev/null -w "%{http_code}\n" ${URL}/graph >> ${SYSTEMCTL_FILE_NAME} &    
done

echo "Systemctl restart http code 000 count:"
cat ${SYSTEMCTL_FILE_NAME} | grep "000" | wc -l

echo "===================================================================================================="

sleep 2

# Start time
startDate=$(date +%T)
# End time
endDate=$(date +%T -d "+3 seconds")

# Reload prometheus with daemon
curl -X POST http://localhost:9090/-/reload
# Check if prometheus is up
while [ "$(date +%T)" != "$endDate" ]; 
do 
    curl --silent -o /dev/null -w "%{http_code}\n" ${URL}/graph >> ${DAEMON_FILE_NAME} &
done

echo "Daemon reload http code 000 count:"
cat ${DAEMON_FILE_NAME} | grep "000" | wc -l