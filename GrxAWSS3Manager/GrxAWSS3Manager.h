//
//  SparkAWSS3Manager.h
//  AWSS3Demo03
//
//  Created by GRX on 2022/3/2.
//  Copyright © 2022 codew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSS3/AWSS3.h>
NS_ASSUME_NONNULL_BEGIN

@interface GrxAWSS3Manager : NSObject
/** 开始上传 */
typedef void (^AwsStartBlock)(AWSTask *task);
/** 上传完成 */
typedef void (^AwssCompletionBlock)(AWSS3TransferUtilityUploadTask *task, NSError *error);
/** 下载完成 */
typedef void (^AwssDownCompletionBlock)(AWSS3TransferUtilityDownloadTask *task, NSError *error);
/** 正在上传 */
typedef void (^AwsProgressBlock)(AWSS3TransferUtilityTask *task, NSProgress *progress);
+ (GrxAWSS3Manager *)shared;
/*! 初始化 */
- (void)initAWSS3WithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey;
/** 上传图片 */
- (void)uploadData:(NSData *)imageData withStartBlock:(AwsStartBlock)startBlock withProgressBlock:(AwsProgressBlock)progressblock withCompletionBlock:(AwssCompletionBlock)comBlock;
/** 上传文件 */
- (void)uploadFile:(NSString *)fileUrlStr
    withServerPath:(NSString *)serverPath
    withStartBlock:(AwsStartBlock)startBlock withProgressBlock:(AwsProgressBlock)progressblock withCompletionBlock:(AwssCompletionBlock)comBlock;
/** 下载文件 */
- (void)downloadDataStartBlock:(AwsStartBlock)startBlock withProgressBlock:(AwsProgressBlock)progressblock withCompletionBlock:(AwssDownCompletionBlock)comBlock;
@end

/** 随机数 */
@interface IdGenerator : NSObject
+ (long long)next;
@end

NS_ASSUME_NONNULL_END
