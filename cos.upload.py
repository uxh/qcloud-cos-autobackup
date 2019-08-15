# -*- coding=utf-8

from qcloud_cos import CosConfig
from qcloud_cos import CosS3Client
import sys
import logging

logging.basicConfig(level=logging.INFO, stream=sys.stdout)

# 设置用户配置
if ( len(sys.argv) > 5 ):
    #设置用户的secretId
    secret_id = sys.argv[1].decode('utf-8')
    #设置用户的secretKey
    secret_key = sys.argv[2].decode('utf-8')
    #设置用户的Region
    region = sys.argv[3].decode('utf-8')
    #设置用户的Bucket
    bucket = sys.argv[4].decode('utf-8')
    #设置用户的本地文件
    localfile = sys.argv[5].decode('utf-8')
    #设置用户的远程文件
    cosfile = sys.argv[6].decode('utf-8')
else:
    print("Example: python %s SecretID SecretKey Region Bucket /data/backup.zip backup.zip" % sys.argv[0])
    exit()

token = None
scheme = 'https'
config = CosConfig(Region=region, SecretId=secret_id, SecretKey=secret_key, Token=token, Scheme=scheme)

# 设置客户端对象
client = CosS3Client(config)

# 高级上传接口
response = client.upload_file(
    Bucket=bucket,
    LocalFilePath=localfile,
    Key=cosfile,
    PartSize=10,
    MAXThread=10,
    EnableMD5=False
)
print(response['ETag'])
