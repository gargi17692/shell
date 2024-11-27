#!/usr/bin/env bash

<< cat
cat << Gargi | grep "this"
The user is: $USER
The home for this $USER is: $HOME
Gargi
cat

<< echo
echo -e "This is first line\nThis is second line"
echo -n "This is third line"
echo "This is fouth line"
echo

# [[ -x filecrn.sh ]] && echo "file has execution permission" || echo "file don't have execution permission"

# cat /etc/os-release | grep -w "NAME" | awk -F "NAME=" '{print $2}' | tr '"' ' '
# Ubuntu 

# declare -a git_vers
# echo "****** Please wait collecting all versions of git form git_vers ******"
# while read line
# do
#     #echo $line | sed -n '/git-\([0-9]\+\.\)\+tar.gz/p' | awk -F '"' '{print $2}' | cut -c 5- | awk -F '.tar.gz' '{print $1}'
#     git_vers+=($(echo $line | sed -n '/git-\([0-9]\+\.\)\+tar.gz/p' | awk -F '"' '{print $2}' | cut -c 5- | awk -F '.tar.gz' '{print $1}'))
# done < index.html

# echo "The available git versions are : "
# echo "${git_vers[*]}"

# cnt=0
# no_vers=${#git_vers[*]}
# # echo "No of available git versions are : $no_vers"
# WIDTH=10
# for each_ver in ${git_vers[*]}
# do
#     #echo -e "\t\t ${git_vers[$cnt]} \\t ${git_vers[$((cnt+1))]} \\t ${git_vers[$((cnt+2))]}"
#     printf "%-*s %-*s %-*s %-*s %-*s %-*s %-*s %-*s\n" $WIDTH ${git_vers[$cnt]} $WIDTH ${git_vers[$((cnt+1))]} $WIDTH ${git_vers[$((cnt+2))]} $WIDTH ${git_vers[$((cnt+3))]} $WIDTH ${git_vers[$((cnt+4))]} $WIDTH ${git_vers[$((cnt+5))]} 
#     cnt=$((cnt+6))
#     if [ $cnt -ge $no_vers ]
#     then
#         break
#     fi
# done


git_ver=$(git --version | awk  '{print $3}')
read -e -i ${git_ver} -p "enter a word , (yes/no)" GIT_TO_INSTALL

echo "${git_ver}"
echo "${GIT_TO_INSTALL}"