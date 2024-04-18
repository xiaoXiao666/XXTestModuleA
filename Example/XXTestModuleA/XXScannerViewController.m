//
//  XXScannerViewController.m
//  XXTestModuleA_Example
//
//  Created by xiao xiao on 2024/4/17.
//  Copyright © 2024 xiaoXiao666. All rights reserved.
//

#import "XXScannerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface XXScannerViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong)AVCaptureSession *captureSession;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic,strong)AVCaptureMetadataOutput *metadataOutput;
@end

@implementation XXScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)scan{
    //创建一个新的capture session
    _captureSession = [[AVCaptureSession alloc]init];
    //获取相机输入设备
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //添加视频输入到session
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    
    //初始化metadata output并添加到session
    _metadataOutput = [[AVCaptureMetadataOutput alloc]init];
    [_captureSession addOutput:_metadataOutput];
    
    //设置metada output 的代理为当前控制器
    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    //创建一个预览图层并添加到试图上
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _videoPreviewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    //开始session
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_captureSession startRunning];
    });
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //检查是否有二维码元数据对象
    AVMetadataObject *metadataObject = [metadataObjects firstObject];
    if (metadataObject) {
        NSLog(@"didOutputMetadataObjects-%@",metadataObject);
        [_captureSession stopRunning];
    }
}


@end
