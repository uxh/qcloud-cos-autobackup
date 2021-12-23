# 使用说明

## 注意

以下所有操作都是默认在**CentOS7 x64**系统下进行的，其他系统暂未测试。

## 安装腾讯云官方 SDK（Python 版）

1、安装 pip 工具

```bash
yum install -y python-pip
```

如果提示“No package python-pip available”请先运行下列命令，再运行上述命令

```bash
yum install -y epel-release && yum install -y yum-utils && yum-config-manager --enable epel
```

2、更新 pip 工具

```bash
pip install --upgrade "pip < 21.0"
```

3、安装 SDK

```bash
pip install -U cos-python-sdk-v5 --ignore-installed
```

4、安装其他依赖

```bash
yum install -y wget zip
```

## 使用示例

1、下载备份脚本

英文版

```bash
wget --no-check-certificate -O backup.sh https://github.com/uxh/qcloud-cos-autobackup/raw/master/backup.sh
```

中文版

```bash
wget --no-check-certificate -O backup_CN.sh https://github.com/uxh/qcloud-cos-autobackup/raw/master/backup_CN.sh
```

2、下载上传脚本

```bash
wget --no-check-certificate -O cos.upload.py https://github.com/uxh/qcloud-cos-autobackup/raw/master/cos.upload.py
```

3、修改备份脚本参数

请修改备份脚本中第 *16、17、20、21、24、25* 行中的相关配置

4、创建备份目录

```bash
mkdir /home/wwwbackups
```

5、备份网站目录

英文版执行此命令

```bash
bash backup.sh --file 123.com /home/wwwroot/123.com /home/wwwbackups/123.com
```

中文版执行此命令

```bash
bash backup_CN.sh --file 123.com /home/wwwroot/123.com /home/wwwbackups/123.com
```

6、备份网站数据库

英文版执行此命令

```bash
bash backup.sh --db 123.com 123.com_database root w123456 /home/wwwbackups/123.com
```

中文版执行此命令

```bash
bash backup_CN.sh --db 123.com 123.com_database root w123456 /home/wwwbackups/123.com
```
