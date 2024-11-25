#!/usr/bin/env bash

Sever_Name=$(uname -n)
IP_ADDRESS=$(ifconfig | grep -E "eth0|inet" | awk 'NR==3{print $2}')
OS_TYPE=$(uname)
UP_TIME=$(uptime | awk '{print $3}' | cut -d ',' -f 1)

echo "S_No, SERVER_NAME, IP_ADDRESS, OS_TYPE, UPTIME"  > servers_info.csv
echo "1, $Sever_Name, $IP_ADDRESS, $OS_TYPE, $UP_TIME" >> servers_info.csv