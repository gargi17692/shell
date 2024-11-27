#!/usr/bin/env bash
#Auther: GSD
#Version : 1.0

COLUMNS=$(tput cols)
get_date_time(){
    echo "$(date '+%d-%m-%Y %r')"
}
prRed(){
    echo -e "\033[91m$1 \033[00m"
}
prGreen(){
    echo -e "\033[92m$1 \033[00m"
}
prYellow(){
    echo -e "\033[93m$1 \033[00m"
}
prPurple(){
    echo -e "\033[95m$1 \033[00m"
}
prCyan(){
    echo -e "\033[96m$1 \033[00m"
}
prHeader() {
    for each in $(seq 1 $COLUMNS)
    do
        echo -n $1
    done
}
prtxtCentre() {
    title=$1
    printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
}
download_official_git_version_info() {
    GIT_VERS_URL="https://mirrors.edge.kernel.org/pub/software/scm/git/"
    GIT_VERS_FILE="git_vers_info.html"

    if [ -e "${GIT_VERS_FILE}" ]
    then
        prYellow "$(get_date_time) Found old ${GIT_VERS_FILE}. Deleting old file and Downloading new content. Please wait.."
        rm -rf ${GIT_VERS_FILE}
    else
        prGreen "$(get_date_time) Downloading git versions info. Please wait..."
    fi

    which wget 1>/dev/null 2>/dev/null 
    if [ $? -ne 0 ]
    then
        prRed "$(get_date_time) Sorry unable to download, wget command not found in the host. Please install wget and retry "
        exit 1
    fi

    wget ${GIT_VERS_URL} --output-document=${GIT_VERS_FILE} 1>/dev/null 2>&1
    if [ $? -ne 0 ]
    then
        prRed "$(get_date_time) Unable to dowload. Please try the bellow command manually and verify"
        prPurple "$(get_date_time) wget ${GIT_VERS_URL} --output-document=${GIT_VERS_FILE}"
        exit 2
    else
        prGreen "$(get_date_time) Successfully downloaded git versions from git-scm and stored info in to file : ${GIT_VERS_FILE}"
        
    fi
}
display_all_available_git_versions() {
    if [ ! -e ${GIT_VERS_FILE} ]
    then
        prRed "$(get_date_time) Unable to find the ${GIT_VERS_FILE}"
    fi
    prPurple "$(get_date_time) Sorting git versions. Please Wait..."
    declare -a git_vers
    while read line
    do
        git_vers+=($(echo $line | sed -n '/git-\([0-9]\+\.\)\+tar.gz/p' | awk -F '"' '{print $2}' | cut -c 5- | awk -F '.tar.gz' '{print $1}'))
    done < ${GIT_VERS_FILE}
    prHeader "="
    prtxtCentre "$(get_date_time) Displaying all available git versions"
    cnt=0
    no_vers=${#git_vers[*]}
    # echo "No of available git versions are : $no_vers"
    WIDTH=14
    prHeader "="
    for each_ver in ${git_vers[*]}
    do
        printf "%-*s %-*s %-*s %-*s %-*s %-*s %-*s %-*s %-*s\n" $WIDTH ${git_vers[$cnt]} $WIDTH ${git_vers[$((cnt+1))]} $WIDTH ${git_vers[$((cnt+2))]} $WIDTH ${git_vers[$((cnt+3))]} $WIDTH ${git_vers[$((cnt+4))]} $WIDTH ${git_vers[$((cnt+5))]} $WIDTH ${git_vers[$((cnt+6))]} $WIDTH ${git_vers[$((cnt+7))]} $WIDTH ${git_vers[$((cnt+8))]}
        cnt=$((cnt+9))
        if [ $cnt -ge $no_vers ]
        then
            break
        fi
    done
    prHeader "="
}
display_existing_git_info() {
    which git 1>/dev/null 2>$1
    if [ $? -ne 0 ]
    then
        prCyan "$(get_date_time) select git version to install"
        return 0
    fi
    git_ver=$(git --version | awk '{print $3}')
    prCyan "$(get_date_time) The existing git version : $git_ver "
    return 1
}
display_current_host_git_version() {
    which git 1>/dev/null 2>&1
     if [ $? -eq 0 ]
     then
        prPurple "$(get_date_time) : The Current Git On The Host is : $(git --version)"
    else
        if [ -e "$git_path/git_bkp" ]
        then
            $git_path/git_bkp $git_path/git
        fi
    fi
}
get_git_install_location(){
    which git 1>/dev/null 2>&1
    if [ $? -eq 0 ]
    then
        git_path=$(dirname $(which git))
        mv $git_path/git $git_path/git_bkp
        echo $git_path
    else
        echo '/usr/local'
    fi
}
install_update_git() {
    req_git=$1
    git_loc=$(get_git_install_location)
    url_for_req_git="https://mirrors.edge.kernel.org/pub/software/scm/git/git-${req_git}.tar.gz"
    echo "$(get_date_time) : Downloading ----> $url_for_req_git"
    if [ ! -e "git-${req_git}.tar.gz" ]
    then
        wget $url_for_req_git
    fi
    echo "$(get_date_time) : Extracting git-${req_git}.tar.gz...."
    if [ ! -e git-${req_git} ]
    then
        tar -xvzf git-${req_git}.tar.gz
    fi
    which gcc 1>/dev/null 2>/dev/null || apt install gcc -y
    cd git-${req_git}; ./configure ; make ; make inatall

}

main() {
    clear
    prHeader "="
    prtxtCentre "Welcome To Automating GIT installation With Bash Shell Scripting"
    prHeader "="
    prCyan "$(get_date_time) Checking all available git versions from official git-scm website. Please Wait.... "
    download_official_git_version_info
    display_all_available_git_versions
    display_existing_git_info
    if [ $? -eq 0 ]
    then
        read -p "$(get_date_time) Enter your required git version to install: " GIT_TO_INSTALL
        install_update_git $GIT_TO_INSTALL
        display_current_host_git_version
    else
        read -e -i no -p "$(get_date_time) Do you want to upgrade/downgrade ? (yes/no)" GIT_CNF
        GIT_CNF=${GIT_CNF,,}
        if [ "${GIT_CNF}" == "yes" ]
        then
            read -e -i ${git_ver} -p "$(get_date_time) Enter Your required git version to Install" GIT_TO_INSTALL
            if [ "${GIT_TO_INSTALL}" == "${git_ver}" ]
            then
                prRed "$(get_date_time) Thank You for using $0 script"
                prHeader "="
                exit 0
            fi
            if [ "${GIT_TO_INSTALL}" \< "${git_ver}" ]
            then
                prGreen "$(get_date_time) Downgrading existing git ${git_ver} to rquired git ${GIT_TO_INSTALL}, Please Wait..."
                install_update_git $GIT_TO_INSTALL
                display_current_host_git_version
                prHeader "="
                exit 0
            fi
        else 
            prGreen "$(get_date_time) Thank you for using $0 script"
        fi
    fi
}

if [ "${USER}" != "codespace" ]
then
    prRed "$(get_date_time) Please run this script with $(id -un) user"
    exit 1
else
    main
fi