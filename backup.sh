#! /usr/bin/env bash
PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin"
export PATH

COSSecretID=???
COSSecretKEY=???
COSRegion=???
COSBucket=???

AutoDelete=n
zippassword=123456

baseDir=$(cd `dirname $0`; pwd)
DATE=$(date +%u)
ZIP=$(which zip)
PYTHON=$(which python)
MYSQLDUMP=$(which mysqldump)

uploadToCOS() {
    ${PYTHON} ${baseDir}/cos.upload.py ${COSSecretID} ${COSSecretKEY} ${COSRegion} ${COSBucket} $1 $2
    if [[ $? -eq 0 ]] &&  [[ "$AutoDelete" == "y" ]]
    then
        test -f $1 && rm -f $1
    fi
}

HelpINFO() {
}

backupDB() {
    domain=$1
    dbname=$2
    mysqluser=$3
    mysqlpassword=$4
    back_path=$5
    cd ${back_path}
    ${MYSQLDUMP} -hlocalhost -u${mysqluser} -p${mysqlpassword} ${dbname} --skip-lock-tables --default-character-set=utf8 > ${back_path}/${domain}\_db_${DATE}\.sql
    test -f ${back_path}/${domain}\_db_${DATE}\.zip && rm -f ${back_path}/${domain}\_db_${DATE}\.zip
    ${ZIP} -P${mypassword} -m ${back_path}/${domain}\_db_${DATE}\.zip ${domain}\_db_${DATE}\.sql
    uploadToCOS ${back_path}/${domain}\_db_${DATE}\.zip ${domain}\_db_${DATE}\.zip
}

backupFile() {
    domain=$1
    site_path=$2
    back_path=$3
    test -f ${back_path}/${domain}\_${DATE}\.zip && rm -f ${back_path}/${domain}\_${DATE}\.zip
    ${ZIP} -P${zippassword} -9r ${back_path}/${domain}\_${DATE}\.zip ${site_path}
    uploadToCOS ${back_path}/${domain}\_${DATE}\.zip ${domain}\_${DATE}\.zip
}

while [ $1 ]; do
    case $1 in
        '--db' )
        backupDB $2 $3 $4 $5 $6
        exit
        ;;
        '--file' )
        backupFile $2 $3 $4
        exit  
        ;;
        * )
        HelpINFO
        exit
        ;;
    esac
done
HelpINFO