#!/bin/bash

# tsh ls 명령어를 실행하고 Labels 열에서 hostname 정보만 정확히 추출
hostnames=$(tsh ls -v | sed -n 's/.*hostname=\([^,]*\).*/\1/p')

# 줄바꿈을 기준으로 hostname을 배열로 변환
IFS=$'\n' read -d '' -r -a hostname_array <<< "$hostnames"

# for 루프를 사용하여 각 hostname을 echo로 출력하고 SSH 명령 실행
for hostname in "${hostname_array[@]}"
do
		## Agent hostname 확인
    echo "Hostname: $hostname"
    tsh ssh ubuntu@hostname=$hostname "hostname"
    
    ## Agent Version 업그레이드
    # tsh ssh ubuntu@hostname=$hostname "curl https://goteleport.com/static/install.sh | bash -s 15.4.19 && sudo systemctl restart teleport" 
    
    ## Agent Version 확인
    tsh ssh ubuntu@hostname=$hostname "teleport version"     
done