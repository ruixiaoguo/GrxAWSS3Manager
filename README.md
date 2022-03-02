# GrxAWSS3-iOS
iOS: 亚马逊AWSS3简化集成(文件上传下载)
[官网](https://us-east-1.signin.aws.amazon.com)
[Github](https://github.com/aws-amplify/aws-sdk-ios)

## Prerequisites
* iOS 10.0+
* ObjC、Swift

## Installation
* pod 'AWSS3'
* 导入GrxAWSS3Manager
*  初始化配置AccessKey和secretKey
*  上传、下载配置S3BucketName，S3UploadKeyName，S3DownloadFileName

## Features
### 上传文件
```
[GrxAWSS3Manager.shared uploadData:data withStartBlock:^(AWSTask * _Nonnull task) {
                    if (task.error) {
                        NSLog(@"Error: %@", task.error);
                    }else{
                        NSLog(@"开始上传...");
                    }
                } withProgressBlock:^(AWSS3TransferUtilityTask * _Nonnull task, NSProgress * _Nonnull progress) {
                    NSLog(@"正在上传...");
                } withCompletionBlock:^(AWSS3TransferUtilityUploadTask * _Nonnull task, NSError * _Nonnull error) {
                    if (error) {
                        NSLog(@"上传失败！！！");
                    } else {
                        NSLog(@"上传成功！！！");
                    }
                }];
```

### 下载文件

```
[GrxAWSS3Manager.shared downloadDataStartBlock:^(AWSTask * _Nonnull task) {
                    if (task.error) {
                        NSLog(@"Error: %@", task.error);
                    }else{
                        NSLog(@"开始下载...");
                    }
                } withProgressBlock:^(AWSS3TransferUtilityTask * _Nonnull task, NSProgress * _Nonnull progress) {
                    NSLog(@"正在下载...");
                } withCompletionBlock:^(AWSS3TransferUtilityDownloadTask * _Nonnull task, NSError * _Nonnull error) {
                    if (error) {
                        NSLog(@"下载失败！！！");
                    } else {
                        NSLog(@"下载成功！！！");
                    }
        }];
```
