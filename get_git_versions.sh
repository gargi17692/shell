#!/usr/bin/env bash

which wget 1>/dev/null 2>/dev/null 
if [ $? -ne 0 ]
then
    echo "Please install wget and retry.."
    exit 1
fi

if [ -e "index.html" ]
then
    echo "removing old index.html"
    rm -rf index.html
fi

url="https://http//mirror.edge.kernel.org/pub/software/scm/git/"
wget $url
if [ $? -ne 0 ]
then
    echo "Unable to download form $url"
    exit 2
fi

declare -a git_vers
echo "*************8please wait collecting all versions of git form git official website***********************"
while read line
do
    #echo $line | sed '/git-[0-9]\+\./p' 
    git_vers+=($(echo $line | sed '/git-\([0-9]\+\.\)\+tar.gz/p' | awk -F '"' '{ print $2 }' | cut -c 5- | awk -F '.tar.gz' '{ print $1 }'))
done < index.html

cnt=0
no_vars=${#git_vers[*]}
WIDTH=20
for each_ver in ${git_vers[*]}
do
    #echo -e "\t\t ${git_vers[$cnt]} \\t ${git_vers[$((cnt+1))]} \\t ${git_vers[$((cont+2))]}"
    printf "%-*s %-*s %-*s\n" $WIDTH ${git_vers[$cnt]} $WIDTH ${git_vers[$((cnt+1))]} $WIDTH ${git_vers[$((cont+2))]}
    cnt=$((cnt+3))
    if [[ $cnt -ge $no_vars ]]
    then
        break
    fi
done



