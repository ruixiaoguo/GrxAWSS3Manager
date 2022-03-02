//
//  ViewController.m
//  GrxAWSS3Manager
//
//  Created by GRX on 2022/3/2.
//

#import "ViewController.h"
#import "GrxAWSS3Manager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *upLoadBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 250, 200, 40)];
    upLoadBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:upLoadBtn];
    [upLoadBtn setTitle:@"上传" forState:UIControlStateNormal];
    [upLoadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    upLoadBtn.layer.borderWidth = 1;
    upLoadBtn.layer.cornerRadius = 5;
    [upLoadBtn addTarget:self action:@selector(upLoadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *downBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 320, 200, 40)];
    downBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:downBtn];
    [downBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    downBtn.layer.borderWidth = 1;
    downBtn.layer.cornerRadius = 5;
    [downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)upLoadBtnClick{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage * image = [UIImage imageNamed:@"FindUsBg"];
        NSData *data =  UIImageJPEGRepresentation(image, 1.0f);
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
    });
}


-(void)downBtnClick{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
    });
}
@end
