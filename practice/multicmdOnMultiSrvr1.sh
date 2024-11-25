#!/usr/bin/env bash

# ssh_options="ssh -f remotepass ssh -n -o StrictKeyChecking=NO -o PubkeyAuthentication=No devops" 
# $ssh_options@172.17.0.1 "cat /etc/os-release" | grep -w "NAME" | awk -F "NAME=" '{print $2}' | tr  -d '"'

# remotepass is the password file - YXV0b21hdGlvbgo=
# remoteuser devops
# remote servers list_of_server # 172.31.81.7 172.25.89.8

print_header(){
    printf "@%0.s" $(seq 1 $(tput cols))
    printf "\n"
}

center_msg(){
    msg=$1
    terminalcol=$(tput cols)
    msg_len=$(echo ${#1})
    pre_space=$(($((terminalcol-msg_len))/2))

    print_header
    printf " %0.s" $(seq 1 $pre_space)
    printf "%s" "$1"
    printf "\n"
    print_header
}

check_remotepass(){
    if [ ! -e "remotepass" ]
    then
        center_msg "Please store your password in >>remotepass<< file and retry"
        exit 1
    fi
}

check_remoteuser(){
    if [ ! -e "remoteuser" ]
    then
        center_msg "Please store your user in >>remoteuser<< file and retry"
        exit 2 
    fi 
}

check_list_of_servers(){
    if [ ! -e "remoteservers" ]
    then
        center_msg "please store your servers ip/fqdn name in >>remoteservers<< file and retry"
        exit 3
    fi
}

center_msg "Welcome To Inventory Script"
check_remotepass
check_remoteuser
check_list_of_servers
ssh_options="ssh -f remotepass ssh -n -o StrictKeyChecking=NO -o PubkeyAuthentication=No devops"

echo "Sl.No, ServerName, OS_Type, OS_Version, Arc_Type, CPU_Type," > Servers_Info.csv
while read server
do
    echo "Working on $server"
    OS_Type=$($ssh_options@$server "cat /etc/os-release" | grep -w "NAME" | awk -F "NAME=" '{print $2}' | tr -d '"')
    echo "$OS_Type" | grep -i "ubuntu" 1>/dev/null 2>&1
    if [ $? -eq 0 ]
    then
        OS_Version=$($ssh_options@$server "cat /etc/os-release" | grep "VERSION_ID" | awk -F "VERSION_ID=" '{print $2}'| tr -d '"')
    else
        OS_Version=$($ssh_options@$server "cat /etc/readhat-release" | awk -F "release" '{print $2}' | awk '{print $1}')
    fi
    Arc_Type=$(uname -p)
    CPU_Type=$(cat /proc/cpuinfo | grep "model name" | uniq | awk -F : '{print $2}')
    echo "OS_Type=$OS_Type"
    echo "OS_Version=$OS_Version"
    echo "ARC_Type=$Arc_Type"
    echo "CPU_Type=$CPU_Type"
    echo "1, $server, $OS_Type, $OS_Version, $Arc_Type, $CPU_Type"  >> Servers_Info.csv
done < remoteservers

center_msg "Thanks for Using this script"
