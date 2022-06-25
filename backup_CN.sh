#! /usr/bin/env bash
PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin"
export PATH

#托管：https://github.com/uxh/qcloud-cos-autobackup
#作者：https://www.banwagongzw.com & https://www.vultrcn.com
#致谢：https://zhangge.net

#设置输出颜色
red="\033[0;31m"
green="\033[0;32m"
yellow="\033[0;33m"
plain="\033[0m"

#腾讯云API密钥
apisecretid="x2L3EQpp63QLTdEUXpRkkRZmN8dkL3kpK8QG" #需要修改
apisecretkey="F9Ja7SbIYRYYdaCD9PyA8UZUvqcc1DG4" #需要修改

#腾讯云COS配置
cosregion="ap-shanghai" #需要修改
cosbucket="example-1234567890" #需要修改

#压缩包配置
zippassword="1234567890" #需要修改
zipautodelete="true" #需要修改

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
    echo -e "[${yellow}用法示例${plain}]："
    echo -e "[${green}备份网站目录${plain}]"
    echo -e " bash backup.sh --file 123.com /home/wwwroot/123.com /home/wwwbackups/123.com"
    echo -e "[${green}备份数据库${plain}]"
    echo -e " bash backup.sh --db 123.com 123.com_database root 123456 /home/wwwbackups/123.com"
}

function upload_to_cos() {
    local localfile=$1
    local cosfile=$2

    ${PYTHON} ${Bashdir}/cos.upload.py ${apisecretid} ${apisecretkey} ${cosregion} ${cosbucket} ${localfile} ${cosfile}
    if [ $? -eq 0 ]; then
        echo -e "[${green}提示${plain}] 备份文件 ${localfile} 上传腾讯云成功"
        if [ "${zipautodelete}" == "true" ]; then
            rm -f ${localfile} && echo -e "[${green}提示${plain}] 本地备份文件 ${localfile} 已删除"
        fi
    else
        echo -e "[${red}错误${plain}] 备份文件 ${localfile} 上传腾讯云失败，请重试！"
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
        echo -e "[${green}提示${plain}] 网站目录 ${websitedir} 压缩成功"
    else
        echo -e "[${red}错误${plain}] 网站目录 ${websitedir} 压缩失败，请重试！"
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
        echo -e "[${green}提示${plain}] 数据库 ${databasename} 导出成功"
    else
        echo -e "[${red}错误${plain}] 数据库 ${databasename} 导出失败，请重试！"
    fi
    if [ -f ${backupdir}/${domain}\_db_${Date}\.zip ]; then
        rm -f ${backupdir}/${domain}\_db_${Date}\.zip
    fi
    ${ZIP} -P ${zippassword} -m ${backupdir}/${domain}\_db_${Date}\.zip ${domain}\_db_${Date}\.sql
    if [ $? -eq 0 ]; then
        echo -e "[${green}提示${plain}] 数据库 ${databasename} 压缩成功"
    else
        echo -e "[${red}错误${plain}] 数据库 ${databasename} 压缩失败，请重试！"
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
