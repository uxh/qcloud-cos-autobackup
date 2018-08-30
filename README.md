# 注意
以下所有操作都是默认在 ***CentOS7 x64*** 系统下进行的，其他系统暂未测试。
# 一、安装腾讯云官方 SDK（Python 版）
## 安装 pip 工具
`yum install -y python-pip`<br>
如果提示 *No package python-pip available* 请先运行下列命令，再运行上述命令<br>
`yum install -y epel-release && yum install -y yum-utils && yum-config-manager --enable epel`
## 更新 pip 工具
`pip install --upgrade pip`
## 安装 SDK
`pip install -U cos-python-sdk-v5`
# 二、使用示例
## 安装 wget 工具
`yum install -y wget`
## 安装 zip 工具
`yum install -y zip`
## 下载备份脚本
英文版<br>
`wget --no-check-certificate -O backup.sh https://github.com/uxh/qcloud-cos-autobackup/raw/master/backup.sh`<br>
中文版<br>
`wget --no-check-certificate -O backup_CN.sh https://github.com/uxh/qcloud-cos-autobackup/raw/master/backup_CN.sh`
## 修改脚本参数
请修改脚本中第 *16、17、20、21、24、25* 行中的相关配置
## 下载上传脚本
`wget --no-check-certificate -O cos.upload.py https://github.com/uxh/qcloud-cos-autobackup/raw/master/cos.upload.py`<br>
## 创建备份目录
`mkdir /home/wwwbackups`
## 备份网站目录
英文版<br>
`bash backup.sh --file 123.com /home/wwwroot/123.com /home/wwwbackups/123.com`<br>
中文版<br>
`bash backup_CN.sh --file 123.com /home/wwwroot/123.com /home/wwwbackups/123.com`
## 备份网站数据库
英文版<br>
`bash backup.sh --db 123.com 123.com_database root w123456 /home/wwwbackups/123.com`<br>
中文版<br>
`bash backup_CN.sh --db 123.com 123.com_database root w123456 /home/wwwbackups/123.com`
