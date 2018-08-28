# -*- coding=utf-8

from qcloud_cos import CosConfig
from qcloud_cos import CosS3Client
import sys
import logging

logging.basicConfig(level=logging.INFO, stream=sys.stdout)

if ( len(sys.argv) > 5 ):
    secret_id = sys.argv[1].decode('utf-8')
    secret_key = sys.argv[2].decode('utf-8')
    region = sys.argv[3].decode('utf-8')
    bucket = sys.argv[4].decode('utf-8')
    localfile = sys.argv[5].decode('utf-8')
    cosfilename = sys.argv[6].decode('utf-8')
else:
    print("Example: python %s SecretID SecretKEY Region Bucket /data/backup.zip backup.zip" % sys.argv[0])
    exit()

token = None
scheme = 'https'
config = CosConfig(Region=region, SecretId=secret_id, SecretKey=secret_key, Token=token, Scheme=scheme)
client = CosS3Client(config)

response = client.upload_file(
    Bucket=bucket,
    LocalFilePath=localfile,
    Key=cosfilename,
    PartSize=10,
    MAXThread=10
)
print(response['ETag'])
