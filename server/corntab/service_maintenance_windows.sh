#!/bin/bash

API_KEY=""
ICP_SEV1_SERVICE_ID=P8G97YQ

# 매개변수로 요일을 받음
DAY_OF_WEEK=$1

if [ "$DAY_OF_WEEK" = "fri" ]; then
  # 금요일에 실행되는 스크립트
  MAINTENANCE_WINDOWS_START_DATE=$(date +%Y-%m-%dT18:00:00)
  MAINTENANCE_WINDOWS_END_DATE=$(date +%Y-%m-%dT09:00:00 -d 'next mon')

  echo "Maintenance Windows Start Date: ${MAINTENANCE_WINDOWS_START_DATE}"
  echo "Maintenance Windows End Date: ${MAINTENANCE_WINDOWS_END_DATE}"

  curl --request POST \
    --url https://api.pagerduty.com/maintenance_windows \
    --header 'Accept: application/vnd.pagerduty+json;version=2' \
    --header "Authorization: Token token=${API_KEY}" \
    --header 'Content-Type: application/json' \
    --data "{
    \"maintenance_window\": {
      \"type\": \"maintenance_window\",
      \"start_time\": \"${MAINTENANCE_WINDOWS_START_DATE}\",
      \"end_time\": \"${MAINTENANCE_WINDOWS_END_DATE}\",
      \"description\": \"Service suspended outside of working hours\",
      \"services\": [
        {
          \"id\": \"${ICP_SEV1_SERVICE_ID}\",
          \"type\": \"service_reference\"
        }
      ]
    }
  }"

  echo "\n--------------------------------------------------------------------\n"

else
  # 월요일 ~ 목요일에 실행되는 스크립트
  MAINTENANCE_WINDOWS_START_DATE=$(date +%Y-%m-%dT18:00:00)
  MAINTENANCE_WINDOWS_END_DATE=$(date +%Y-%m-%dT09:00:00 -d +1day)

  echo "Maintenance Windows Start Date: ${MAINTENANCE_WINDOWS_START_DATE}"
  echo "Maintenance Windows End Date: ${MAINTENANCE_WINDOWS_END_DATE}"

  curl --request POST \
    --url https://api.pagerduty.com/maintenance_windows \
    --header 'Accept: application/vnd.pagerduty+json;version=2' \
    --header "Authorization: Token token=${API_KEY}" \
    --header 'Content-Type: application/json' \
    --data "{
    \"maintenance_window\": {
      \"type\": \"maintenance_window\",
      \"start_time\": \"${MAINTENANCE_WINDOWS_START_DATE}\",
      \"end_time\": \"${MAINTENANCE_WINDOWS_END_DATE}\",
      \"description\": \"Service suspended outside of working hours\",
      \"services\": [
        {
          \"id\": \"${ICP_SEV1_SERVICE_ID}\",
          \"type\": \"service_reference\"
        }
      ]
    }
  }"

  echo "\n--------------------------------------------------------------------\n"
  
fi