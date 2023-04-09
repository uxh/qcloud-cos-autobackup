# 使用说明

## 注意

本脚本仅在**CentOS7 x64**、**Debian10 x64**、**Debian11 x64**上通过，其他系统暂未测试。

## 安装腾讯云官方 SDK（Python 版）

1、安装 pip 工具

CentOS7 x64：

```bash
yum install -y python-pip
```

如果提示“No package python-pip available”请先运行下列命令，再运行上述命令

```bash
yum install -y epel-release && yum install -y yum-utils && yum-config-manager --enable epel
```

Debian10 x64:

```bash
apt install -y python3-pip
```

Debian11 x64：

```bash
apt install -y python3-pip
```

2、更新 pip 工具

CentOS7 x64：

```bash
pip install --upgrade "pip < 21.0"
```

Debian10 x64:

```bash
pip3 install --upgrade pip
```

Debian11 x64：

```bash
pip install --upgrade pip
```

3、安装 SDK

CentOS7 x64：

```bash
pip install -U cos-python-sdk-v5 --ignore-installed
```

Debian10 x64:

```bash
pip3 install -U cos-python-sdk-v5 --ignore-installed
```

Debian11 x64：

```bash
pip install -U cos-python-sdk-v5 --ignore-installed
```

4、安装其他依赖

CentOS7 x64：

```bash
yum install -y wget zip
```

Debian10 x64：

```bash
apt install -y wget zip
```

Debian11 x64：

```bash
apt install -y wget zip
```

## 使用示例

1、下载备份脚本

```bash
wget --no-check-certificate -O backup.sh https://github.com/uxh/qcloud-cos-autobackup/raw/master/backup.sh
```

2、下载上传脚本

```bash
wget --no-check-certificate -O cos.upload.py https://github.com/uxh/qcloud-cos-autobackup/raw/master/cos.upload.py
```

3、修改备份脚本参数

请修改备份脚本中第 *16、17、20、21、24、25* 行中的相关配置

4、创建备份目录

```bash
mkdir -p /home/wwwbackups
```

5、备份网站目录

```bash
bash backup.sh --file 123.com /home/wwwroot/123.com /home/wwwbackups/123.com
```

6、备份网站数据库

```bash
bash backup.sh --db 123.com 123.com_database root w123456 /home/wwwbackups/123.com
```
