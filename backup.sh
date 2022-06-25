#! /usr/bin/env bash
PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin"
export PATH

#Github：https://github.com/uxh/qcloud-cos-autobackup
#Author：https://www.banwagongzw.com & https://www.vultrcn.com
#Thanks：https://zhangge.net

#Set color
red="\033[0;31m"
green="\033[0;32m"
yellow="\033[0;33m"
plain="\033[0m"

#Qcloud API setting
apisecretid="x2L3EQpp63QLTdEUXpRkkRZmN8dkL3kpK8QG" #needed
apisecretkey="F9Ja7SbIYRYYdaCD9PyA8UZUvqcc1DG4" #needed

#Qcloud COS setting
cosregion="ap-shanghai" #needed
cosbucket="example-1234567890" #needed

#Zip setting
zippassword="1234567890" #needed
zipautodelete="true" #needed

Bashdir=$(cd `dirname $0`; pwd)
Date=$(date +%u)
ZIP=$(which zip)
MYSQLDUMP=$(which mysqldump)
which python > /dev/null 2>&1
if [ $? -ne 0 ]; then
    PYTHON=$(which python)
else
    PYTHON=$(which python3)
fi

function help_info() {
    echo -e "[${yellow}Usage${plain}]："
    echo -e "[${green}Backup web directory${plain}]"
    echo -e " bash backup.sh --file 123.com /home/wwwroot/123.com /home/wwwbackups/123.com"
    echo -e "[${green}Backup web database${plain}]"
    echo -e " bash backup.sh --db 123.com 123.com_database root 123456 /home/wwwbackups/123.com"
}

function upload_to_cos() {
    local localfile=$1
    local cosfile=$2

    ${PYTHON} ${Bashdir}/cos.upload.py ${apisecretid} ${apisecretkey} ${cosregion} ${cosbucket} ${localfile} ${cosfile}
    if [ $? -eq 0 ]; then
        echo -e "[${green}INFO${plain}] Backup ${localfile} upload to Qcloud COS success"
        if [ "${zipautodelete}" == "true" ]; then
            rm -f ${localfile} && echo -e "[${green}INFO${plain}] Backup ${localfile} has been deleted"
        fi
    else
        echo -e "[${red}ERROR${plain}] Backup ${localfile} upload to Qcloud COS failed, please try again!"
    fi
}

function backup_file() {
    local domain=$1
    local websitedir=$2
    local backupdir=$3

    if [ ! -d ${backupdir} ]; then
        mkdir ${backupdir}
    fi
    if [ -f ${backupdir}/${domain}\_${Date}\.zip ]; then
        rm -f ${backupdir}/${domain}\_${Date}\.zip
    fi
    ${ZIP} -P${zippassword} -9r ${backupdir}/${domain}\_${Date}\.zip ${websitedir}
    if [ $? -eq 0 ]; then
        echo -e "[${green}INFO${plain}] Zip web directory ${websitedir} success"
    else
        echo -e "[${red}ERROR${plain}] Zip web directory ${websitedir} failed, please try again!"
    fi

    upload_to_cos ${backupdir}/${domain}\_${Date}\.zip ${domain}\_${Date}\.zip
}

function backup_db() {
    local domain=$1
    local databasename=$2
    local mysqluser=$3
    local mysqlpassword=$4
    local backupdir=$5

    if [ ! -d ${backupdir} ]; then
        mkdir ${backupdir}
    fi
    cd ${backupdir}
    ${MYSQLDUMP} -hlocalhost -u${mysqluser} -p${mysqlpassword} ${databasename} --skip-lock-tables --default-character-set=utf8 > ${backupdir}/${domain}\_db_${Date}\.sql
    if [ $? -eq 0 ]; then
        echo -e "[${green}INFO${plain}] Mysqldump database ${databasename} success"
    else
        echo -e "[${red}ERROR${plain}] Mysqldump database ${databasename} failes, please try again!"
    fi
    if [ -f ${backupdir}/${domain}\_db_${Date}\.zip ]; then
        rm -f ${backupdir}/${domain}\_db_${Date}\.zip
    fi
    ${ZIP} -P ${zippassword} -m ${backupdir}/${domain}\_db_${Date}\.zip ${domain}\_db_${Date}\.sql
    if [ $? -eq 0 ]; then
        echo -e "[${green}INFO${plain}] Zip database ${databasename} success"
    else
        echo -e "[${red}ERROR${plain}] Zip database ${databasename} failed, please try again!"
    fi

    upload_to_cos ${backupdir}/${domain}\_db_${Date}\.zip ${domain}\_db_${Date}\.zip
}

while [ $1 ]; do
    case $1 in
        '--file' )
        backup_file $2 $3 $4
        exit  
        ;;
        '--db' )
        backup_db $2 $3 $4 $5 $6
        exit
        ;;
        * )
        help_info
        exit
        ;;
    esac
done
help_info
