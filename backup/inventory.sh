#!/usr/bin/env bash

Sever_Name=$(uname -n)
IP_ADDRESS=$(ifconfig | grep -E "eth0|inet" | awk 'NR==3{print $2}')
OS_TYPE=$(uname)
OS_Name=$(cat /etc/os-release | grep -w "NAME" | awk -F "NAME=" '{print $2}' | tr -d '"')
UP_TIME=$(uptime | awk '{print $3}' | cut -d ',' -f 1)
echo "$OS_Name" | grep -i "ubuntu" 1>/dev/null 2>&1
if [ $? -eq 0 ]
then
    OS_Version=$(cat /etc/os-release | grep "VERSION_ID" | awk -F "VERSION_ID=" '{print $2}'| tr -d '"')
else
    OS_Version=$(cat /etc/readhat-release | awk -F "release" '{print $2}' | awk '{print $1}')
fi
Arc_Type=$(uname -p)
CPU_Type=$(cat /proc/cpuinfo | grep "model name" | uniq | awk -F : '{print $2}')
echo "S_No, SERVER_NAME, IP_ADDRESS, OS_TYPE, OS_NAME, UPTIME, OS_Version, ARC_Type, CPU_Type"  > servers_info.tsv
echo "1, $Sever_Name, $IP_ADDRESS, $OS_TYPE, $OS_Name, $UP_TIME, $OS_Version, $Arc_Type, $CPU_Type" >> servers_info.tsv