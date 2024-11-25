#!/usr/bin/env bash

Sever_Name=$(uname -n)
IP_ADDRESS=$(ifconfig | grep -E "eth0|inet" | awk 'NR==3{print $2}')
OS_TYPE=$(uname)
UP_TIME