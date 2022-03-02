//
//  SparkAWSS3Manager.m
//  AWSS3Demo03
//
//  Created by GRX on 2022/3/2.
//  Copyright © 2022 codew. All rights reserved.
//

#import "GrxAWSS3Manager.h"
#define S3BucketName @"服务器配置桶名字"
#define S3UploadKeyName @"自定义文件夹名字"
#define S3DownloadFileName @"文件名/fbb.png"
@implementation GrxAWSS3Manager

+ (GrxAWSS3Manager *)shared
{
    static GrxAWSS3Manager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[GrxAWSS3Manager alloc]init];
    });
    return share;
}

-(void)initAWSS3WithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey{
    AWSStaticCredentialsProvider * credentialsProvider = [[AWSStaticCredentialsProvider alloc] initWithAccessKey:accessKey secretKey:secretKey];
    // Region 问你们服务器, 如果你能拿到账号自己看, 下面是对照表
    // https://docs.amazonaws.cn/general/latest/gr/rande.html
    AWSServiceConfiguration * configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager] .defaultServiceConfiguration = configuration;
}

- (void)uploadData:(NSData *)imageData withStartBlock:(AwsStartBlock)startBlock withProgressBlock:(AwsProgressBlock)progressblock withCompletionBlock:(AwssCompletionBlock)comBlock{
    AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityUploadTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            comBlock(task,error);
        });
    };
    AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
    expression.progressBlock = ^(AWSS3TransferUtilityTask *task, NSProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressblock(task,progress);
        });
    };
    // application/x-png @"text/plain"
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    NSString *filePath = [NSString stringWithFormat:@"%@/%lld.png",S3UploadKeyName,[IdGenerator next]];
    [[transferUtility uploadData:imageData
                          bucket:S3BucketName
                             key:filePath
                     contentType:@"application/x-png"
                      expression:expression
               completionHandler:completionHandler] continueWithBlock:^id(AWSTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    startBlock(task);
                });
        return nil;
    }];
}
- (void)downloadDataStartBlock:(AwsStartBlock)startBlock withProgressBlock:(AwsProgressBlock)progressblock withCompletionBlock:(AwssDownCompletionBlock)comBlock{
    AWSS3TransferUtilityDownloadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityDownloadTask *task, NSURL *location, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            comBlock(task,error);
        });
    };
    AWSS3TransferUtilityDownloadExpression *expression = [AWSS3TransferUtilityDownloadExpression new];
    expression.progressBlock = ^(AWSS3TransferUtilityTask *task, NSProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressblock(task,progress);
        });
    };
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    [[transferUtility downloadDataFromBucket:S3BucketName
                                         key:S3DownloadFileName
                                  expression:expression
                           completionHandler:completionHandler] continueWithBlock:^id(AWSTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            startBlock(task);
        });        
        return nil;
    }];
}
@end

#pragma mark===================随机数=========================
static long long time_stamp = 0;
static long long time_stamp_now = 0;
static NSMutableArray *temp = NULL;
static NSNumber *random_n = NULL;
static NSLock *theLock = NULL;

@implementation IdGenerator
/*
 *  获取下一个Id
 */
+ (long long)next{
    
    if(theLock == NULL)
        theLock = [[NSLock alloc]init];
    
    if(temp == NULL)
        temp = [[NSMutableArray alloc]init];
    
    @synchronized(theLock){
        time_stamp_now = [[NSDate date] timeIntervalSince1970];
        if(time_stamp_now != time_stamp){
            //清空缓存，更新时间戳
            [temp removeAllObjects];
            time_stamp = time_stamp_now;
        }
        
        //判断缓存中是否存在当前随机数
        while ([temp containsObject:(random_n = [NSNumber numberWithLong:arc4random() % 8999 + 1000])]);
        if ([temp containsObject:random_n]) {
            return -1;
        }
        [temp addObject:[NSNumber numberWithLong:[random_n longValue]]];
    }
    return (time_stamp * 10000) + [random_n longValue];
}
@end
