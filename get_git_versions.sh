#!/usr/bin/env bash

which wget 1>/dev/null 2>/dev/null 
if [ $? -ne 0 ]
then
    echo "Please install wget and retry.."
    exit 1
fi