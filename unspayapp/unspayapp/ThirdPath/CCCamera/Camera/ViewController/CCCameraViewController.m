//
//  CCCameraViewController.m
//  CCCamera
//
//  Created by wsk on 16/8/22.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "CCCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <CoreMedia/CMMetadata.h>

#import "CCCameraView.h"

#import "CCMotionManager.h"
#import "UIView+CCHUD.h"
#import "CCImagePreviewController.h"

#define ISIOS9 __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0

@interface CCCameraViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,CCCameraViewDelegate>
{
    // 会话
    AVCaptureSession          *_captureSession;
    
    // 输入
    AVCaptureDeviceInput      *_deviceInput;
        
    // 输出
    AVCaptureConnection       *_videoConnection;
    AVCaptureConnection       *_audioConnection;
    AVCaptureVideoDataOutput  *_videoOutput;
    AVCaptureStillImageOutput *_imageOutput;
    
    // 文件
    NSURL				      *_movieURL;
    AVAssetWriter             *_assetWriter;
    AVAssetWriterInput	      *_assetAudioInput;
    AVAssetWriterInput        *_assetVideoInput;

    BOOL					   _readyToRecordVideo;
    BOOL					   _readyToRecordAudio;
    BOOL                       _recording;
    dispatch_queue_t           _movieWritingQueue;
}

@property(nonatomic, strong) CCCameraView *cameraView;
@property(nonatomic, strong) CCMotionManager *motionManager;
@property(nonatomic, strong) AVCaptureDevice *activeCamera;   // 当前输入设备
@property(nonatomic, strong) AVCaptureDevice *inactiveCamera; // 不活跃的设备(这里指前摄像头或后摄像头，不包括外接输入设备)
@property(nonatomic, assign) AVCaptureFlashMode currentflashMode; // 当前闪光灯的模式
@property(nonatomic, assign) AVCaptureVideoOrientation	referenceOrientation; // 视频播放方向

@end

@implementation CCCameraViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        _movieURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"movie.mov"]];
        _motionManager = [[CCMotionManager alloc] init];
        _referenceOrientation = AVCaptureVideoOrientationPortrait;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    self.cameraView = [[CCCameraView alloc] initWithFrame:self.view.bounds];
    self.cameraView.delegate = self;
    [self.view addSubview:self.cameraView];
    
    NSError *error;
    [self setupSession:&error];
    if (!error) {
        [self.cameraView.previewView setCaptureSessionsion:_captureSession];
        [self startCaptureSession];
    }
    else{
        [self.view showError:error];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc{
    NSLog(@"相机界面销毁了");
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - -输入设备
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)activeCamera{
    return _deviceInput.device;
}

- (AVCaptureDevice *)inactiveCamera{
    AVCaptureDevice *device = nil;
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1) {
        if ([self activeCamera].position == AVCaptureDevicePositionBack) {
            device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        } else {
            device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}

#pragma mark - -相关配置
// 会话
- (void)setupSession:(NSError **)error{
    _captureSession = [[AVCaptureSession alloc]init];
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self setupSessionInputs:error];
    [self setupSessionOutputs:error];
}

// 输入
- (void)setupSessionInputs:(NSError **)error{
    // 视频输入
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    if (videoInput) {
        if ([_captureSession canAddInput:videoInput]){
            [_captureSession addInput:videoInput];
            _deviceInput = videoInput;
        }
    }
    
    // 音频输入
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioIn = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:error];
    if ([_captureSession canAddInput:audioIn]){
        [_captureSession addInput:audioIn];
    }
}

// 输出
- (void)setupSessionOutputs:(NSError **)error{
    dispatch_queue_t captureQueue = dispatch_queue_create("com.cc.captureQueue", DISPATCH_QUEUE_SERIAL);
    
    // 视频输出
    AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
    [videoOut setAlwaysDiscardsLateVideoFrames:YES];
    [videoOut setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]}];
    [videoOut setSampleBufferDelegate:self queue:captureQueue];
    if ([_captureSession canAddOutput:videoOut]){
        [_captureSession addOutput:videoOut];
        _videoOutput = videoOut;
    }
    _videoConnection = [videoOut connectionWithMediaType:AVMediaTypeVideo];
    _videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    // 音频输出
    AVCaptureAudioDataOutput *audioOut = [[AVCaptureAudioDataOutput alloc] init];
    [audioOut setSampleBufferDelegate:self queue:captureQueue];
    if ([_captureSession canAddOutput:audioOut]){
        [_captureSession addOutput:audioOut];
    }
    _audioConnection = [audioOut connectionWithMediaType:AVMediaTypeAudio];
    
    // 静态图片输出
    AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];            
    imageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    if ([_captureSession canAddOutput:imageOutput]) {
        [_captureSession addOutput:imageOutput];
        _imageOutput = imageOutput;
    }
}

// 音频源数据写入配置
- (BOOL)setupAssetWriterAudioInput:(CMFormatDescriptionRef)currentFormatDescription{
    size_t aclSize = 0;
    const AudioStreamBasicDescription *currentASBD = CMAudioFormatDescriptionGetStreamBasicDescription(currentFormatDescription);
    const AudioChannelLayout *currentChannelLayout = CMAudioFormatDescriptionGetChannelLayout(currentFormatDescription, &aclSize);

    NSData *currentChannelLayoutData = nil;
    if (currentChannelLayout && aclSize > 0){
        currentChannelLayoutData = [NSData dataWithBytes:currentChannelLayout length:aclSize];
    } else {
        currentChannelLayoutData = [NSData data];
    }
    NSDictionary *audioCompressionSettings = @{AVFormatIDKey: [NSNumber numberWithInteger: kAudioFormatMPEG4AAC],
                                               AVSampleRateKey: [NSNumber numberWithFloat: currentASBD->mSampleRate],
                                               AVEncoderBitRatePerChannelKey: [NSNumber numberWithInt: 64000],
                                               AVNumberOfChannelsKey: [NSNumber numberWithInteger: currentASBD->mChannelsPerFrame],
                                               AVChannelLayoutKey: currentChannelLayoutData};

    if ([_assetWriter canApplyOutputSettings:audioCompressionSettings forMediaType: AVMediaTypeAudio]){
        _assetAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType: AVMediaTypeAudio outputSettings:audioCompressionSettings];
        _assetAudioInput.expectsMediaDataInRealTime = YES;
        if ([_assetWriter canAddInput:_assetAudioInput]){
            [_assetWriter addInput:_assetAudioInput];
        } else {
            [self.view showError:_assetWriter.error];
            return NO;
        }
    } else {
        [self.view showError:_assetWriter.error];
        return NO;
    }
    return YES;
}

// 视频源数据写入配置
- (BOOL)setupAssetWriterVideoInput:(CMFormatDescriptionRef)currentFormatDescription
{
    CGFloat bitsPerPixel;
    CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(currentFormatDescription);
    NSUInteger numPixels = dimensions.width * dimensions.height;
    NSUInteger bitsPerSecond;

    if (numPixels < (640 * 480)){
        bitsPerPixel = 4.05;
    } else {
        bitsPerPixel = 11.4;
    }

    bitsPerSecond = numPixels * bitsPerPixel;
    NSDictionary *videoCompressionSettings = @{AVVideoCodecKey:AVVideoCodecH264,
                                               AVVideoWidthKey:[NSNumber numberWithInteger:dimensions.width],
                                               AVVideoHeightKey:[NSNumber numberWithInteger:dimensions.height],
                                               AVVideoCompressionPropertiesKey:@{AVVideoAverageBitRateKey:[NSNumber numberWithInteger:bitsPerSecond],
                                                                                 AVVideoMaxKeyFrameIntervalKey:[NSNumber numberWithInteger:30]}
                                               };
    if ([_assetWriter canApplyOutputSettings:videoCompressionSettings forMediaType:AVMediaTypeVideo]){
        _assetVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoCompressionSettings];
        _assetVideoInput.expectsMediaDataInRealTime = YES;
        _assetVideoInput.transform = [self transformFromCurrentVideoOrientationToOrientation:self.referenceOrientation];
        if ([_assetWriter canAddInput:_assetVideoInput]){
            [_assetWriter addInput:_assetVideoInput];
        } else {
            [self.view showError:_assetWriter.error];
            return NO;
        }
    } else {
        [self.view showError:_assetWriter.error];
        return NO;
    }
    return YES;
}

#pragma mark - -会话控制
// 开启捕捉
- (void)startCaptureSession{
    if (!_movieWritingQueue) {
        _movieWritingQueue = dispatch_queue_create("Movie.Writing.Queue", DISPATCH_QUEUE_SERIAL);
    }
    if (!_captureSession.isRunning){
        [_captureSession startRunning];
    }
}

// 停止捕捉
- (void)stopCaptureSession{
    if (_captureSession.isRunning){
        [_captureSession stopRunning];
    }
}

#pragma mark - -拍摄照片
-(void)takePictureImage{
    AVCaptureConnection *connection = [_imageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (connection.isVideoOrientationSupported) {
        connection.videoOrientation = [self currentVideoOrientation];
    }
    
//    connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    id takePictureSuccess = ^(CMSampleBufferRef sampleBuffer,NSError *error){
        if (sampleBuffer == NULL) {
            [self.view showError:error];
            return ;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
        UIImage *image = [[UIImage alloc]initWithData:imageData];
        
        CCImagePreviewController *vc = [[CCImagePreviewController alloc]initWithImage:image frame:self.cameraView.previewView.frame];
        [vc callBack:^(BOOL flag, NSString *message) {
            if (flag) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.block) {
                        self.block(image,self.cameraView.previewView.frame);
                    }
                }];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }];
//        [self.navigationController pushViewController:vc animated:YES];
        [self presentViewController:vc animated:YES completion:nil];
        

        /*

        */
       
        
    };
    [_imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:takePictureSuccess];
}

- (void)callBack:(CCCameraBlock)cccameraBlock{
    self.block = cccameraBlock;
}

#pragma mark - -录制视频
// 开始录制
- (void)startRecording{
    [self removeFile:_movieURL];
    dispatch_async(_movieWritingQueue, ^{
        if (!_assetWriter) {
            NSError *error;
            _assetWriter = [[AVAssetWriter alloc] initWithURL:_movieURL fileType:AVFileTypeQuickTimeMovie error:&error];
            !error?:[self.view showError:error];
        }
        _recording = YES;
    });
}

// 停止录制
- (void)stopRecording{
    _recording = NO;
    if (![self inputsReadyToRecord]) {
        [self.view showAlertView:@"录制视频出错了" ok:nil cancel:nil];
        return ;
    }
    
    dispatch_async(_movieWritingQueue, ^{
        [_assetWriter finishWritingWithCompletionHandler:^(){
            BOOL isSave = NO; // 是否生成完整的视频
            switch (_assetWriter.status){
                case AVAssetWriterStatusCompleted:{
                    _readyToRecordVideo = NO;
                    _readyToRecordAudio = NO;
                    _assetWriter = nil;
                    isSave = YES;
                    break;
                }
                case AVAssetWriterStatusFailed:{
                    isSave = NO;
                    [self.view showError:_assetWriter.error];
                    break;
                }
                default:
                    break;
            }
            if (isSave) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.view showAlertView:@"是否保存到相册" ok:^(UIAlertAction *act) {
                        [self saveMovieToCameraRoll];
                    } cancel:nil];
                });
            }
        }];
    });
}

// 保存视频
- (void)saveMovieToCameraRoll{
    [self.view showLoadHUD:@"保存中..."];
    if (ISIOS9) {
        [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
            if (status != PHAuthorizationStatusAuthorized) return ;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetCreationRequest *videoRequest = [PHAssetCreationRequest creationRequestForAsset];
                [videoRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:_movieURL options:nil];
            } completionHandler:^( BOOL success, NSError * _Nullable error ) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.view hideHUD];
                });
                success?:[self.view showError:error];
            }];
        }];
    }
    else{
        ALAssetsLibrary *lab = [[ALAssetsLibrary alloc]init];
        [lab writeVideoAtPathToSavedPhotosAlbum:_movieURL completionBlock:^(NSURL *assetURL, NSError *error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.view hideHUD];
            });
            !error?:[self.view showError:error];
        }];
    }
}

#pragma mark - -输出代理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (_recording) {
        CFRetain(sampleBuffer);
        dispatch_async(_movieWritingQueue, ^{
            if (_assetWriter){
                if (connection == _videoConnection){
                    if (!_readyToRecordVideo){
                        _readyToRecordVideo = [self setupAssetWriterVideoInput:CMSampleBufferGetFormatDescription(sampleBuffer)];
                    }
                    if ([self inputsReadyToRecord]){
                        [self writeSampleBuffer:sampleBuffer ofType:AVMediaTypeVideo];
                    }
                } else if (connection == _audioConnection){
                    if (!_readyToRecordAudio){
                        _readyToRecordAudio = [self setupAssetWriterAudioInput:CMSampleBufferGetFormatDescription(sampleBuffer)];
                    }
                    if ([self inputsReadyToRecord]){
                        [self writeSampleBuffer:sampleBuffer ofType:AVMediaTypeAudio];
                    }
                }
            }
            CFRelease(sampleBuffer);
        });
    }
}

- (void)writeSampleBuffer:(CMSampleBufferRef)sampleBuffer ofType:(NSString *)mediaType{
    if (_assetWriter.status == AVAssetWriterStatusUnknown){
        if ([_assetWriter startWriting]){
            [_assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
        } else {
            [self.view showError:_assetWriter.error];
        }
    }
    
    if (_assetWriter.status == AVAssetWriterStatusWriting){
        if (mediaType == AVMediaTypeVideo){
            if (!_assetVideoInput.readyForMoreMediaData){
                return;
            }
            if (![_assetVideoInput appendSampleBuffer:sampleBuffer]){
                [self.view showError:_assetWriter.error];
            }
        } else if (mediaType == AVMediaTypeAudio){
            if (!_assetAudioInput.readyForMoreMediaData){
                return;
            }
            if (![_assetAudioInput appendSampleBuffer:sampleBuffer]){
                [self.view showError:_assetWriter.error];
            }
        }
    }
}

- (BOOL)inputsReadyToRecord{
    return _readyToRecordVideo && _readyToRecordAudio;
}

#pragma mark - -转换前后摄像头
- (void)swicthCameraAction:(CCCameraView *)cameraView succ:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error = [self switchCameras];
    error?!fail?:fail(error):!succ?:succ();
}

- (BOOL)canSwitchCameras{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1;
}

- (id)switchCameras{
    if (![self canSwitchCameras]) return nil;

    NSError *error;
    AVCaptureDevice *videoDevice = [self inactiveCamera];                   
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (videoInput) {
        [_captureSession beginConfiguration];                           
        [_captureSession removeInput:_deviceInput];            
        if ([_captureSession canAddInput:videoInput]) {                 
            [_captureSession addInput:videoInput];
            _deviceInput = videoInput;
        }
        [_captureSession commitConfiguration];
        
        // 如果后置转前置，系统会自动关闭手电筒，如果之前打开的，需要通知camera更新UI
        if (videoDevice.position == AVCaptureDevicePositionFront) {
            [self.cameraView changeTorch:NO];
        }

        // 前后摄像头的闪光灯不是同步的，所以在转换摄像头后需要重新设置闪光灯
        [self changeFlash:_currentflashMode];
        
        // 转换摄像头后，原来的视频输出会无效，所以需要把原来视频输出删除，再重新加一个新的视频输出进去
        [_captureSession beginConfiguration];
        [_captureSession removeOutput:_videoOutput];
        dispatch_queue_t captureQueue = dispatch_queue_create("com.cc.captureQueue", DISPATCH_QUEUE_SERIAL);
        AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
        [videoOut setAlwaysDiscardsLateVideoFrames:YES];
        [videoOut setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]}];
        [videoOut setSampleBufferDelegate:self queue:captureQueue];
        if ([_captureSession canAddOutput:videoOut]) {
            [_captureSession addOutput:videoOut];
            _videoOutput = videoOut;
        }
        _videoConnection = [videoOut connectionWithMediaType:AVMediaTypeVideo];
        _videoConnection.videoOrientation = self.referenceOrientation;
        [_captureSession commitConfiguration];

        return nil;
    } 
    return error;
}

#pragma mark - -聚焦
-(void)focusAction:(CCCameraView *)cameraView point:(CGPoint)point succ:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error = [self focusAtPoint:point];
    error?!fail?:fail(error):!succ?:succ();
}

- (BOOL)cameraSupportsTapToFocus{
    return [[self activeCamera] isFocusPointOfInterestSupported];
}

- (id)focusAtPoint:(CGPoint)point{
    AVCaptureDevice *device = [self activeCamera];
    if ([self cameraSupportsTapToFocus] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]){
        NSError *error;
        if ([device lockForConfiguration:&error]) {                         
            device.focusPointOfInterest = point;
            device.focusMode = AVCaptureFocusModeAutoFocus;
            [device unlockForConfiguration];
        } 
        return error;
    }
    return nil;
}

#pragma mark - -曝光
-(void)exposAction:(CCCameraView *)cameraView point:(CGPoint)point succ:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error = [self exposeAtPoint:point];
    error?!fail?:fail(error):!succ?:succ();
}

- (BOOL)cameraSupportsTapToExpose{
    return [[self activeCamera] isExposurePointOfInterestSupported];
}

static const NSString *CameraAdjustingExposureContext;
- (id)exposeAtPoint:(CGPoint)point{
    AVCaptureDevice *device = [self activeCamera];
    if ([self cameraSupportsTapToExpose] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {                         
            device.exposurePointOfInterest = point;
            device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            if ([device isExposureModeSupported:AVCaptureExposureModeLocked]) {
                [device addObserver:self forKeyPath:@"adjustingExposure" options:NSKeyValueObservingOptionNew context:&CameraAdjustingExposureContext];
            }
            [device unlockForConfiguration];
        } 
        return error;
    }
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == &CameraAdjustingExposureContext) {                     
        AVCaptureDevice *device = (AVCaptureDevice *)object;
        if (!device.isAdjustingExposure && [device isExposureModeSupported:AVCaptureExposureModeLocked]) {
            [object removeObserver:self forKeyPath:@"adjustingExposure" context:&CameraAdjustingExposureContext];
            dispatch_async(dispatch_get_main_queue(), ^{                    
                NSError *error;
                if ([device lockForConfiguration:&error]) {
                    device.exposureMode = AVCaptureExposureModeLocked;
                    [device unlockForConfiguration];
                } else {
                    [self.view showError:error];
                }
            });
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - -自动聚焦、曝光
-(void)autoFocusAndExposureAction:(CCCameraView *)cameraView succ:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error = [self resetFocusAndExposureModes];
    error?!fail?:fail(error):!succ?:succ();
}

- (id)resetFocusAndExposureModes{
    AVCaptureDevice *device = [self activeCamera];
    AVCaptureExposureMode exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    AVCaptureFocusMode focusMode = AVCaptureFocusModeContinuousAutoFocus;
    BOOL canResetFocus = [device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode];
    BOOL canResetExposure = [device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode];
    CGPoint centerPoint = CGPointMake(0.5f, 0.5f);                          
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        if (canResetFocus) {                                                
            device.focusMode = focusMode;
            device.focusPointOfInterest = centerPoint;
        }
        if (canResetExposure) {                                             
            device.exposureMode = exposureMode;
            device.exposurePointOfInterest = centerPoint;
        }
        [device unlockForConfiguration];
    } 
    return error;
}

#pragma mark - -闪光灯
-(void)flashLightAction:(CCCameraView *)cameraView succ:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error = [self changeFlash:[self flashMode] == AVCaptureFlashModeOn?AVCaptureFlashModeOff:AVCaptureFlashModeOn];
    error?!fail?:fail(error):!succ?:succ();
}

- (BOOL)cameraHasFlash{
    return [[self activeCamera] hasFlash];
}

- (AVCaptureFlashMode)flashMode{
    return [[self activeCamera] flashMode];
}

- (id)changeFlash:(AVCaptureFlashMode)flashMode{
    if (![self cameraHasFlash]) {
        NSDictionary *desc = @{NSLocalizedDescriptionKey:@"不支持闪光灯"};
        NSError *error = [NSError errorWithDomain:@"com.cc.camera" code:401 userInfo:desc];
        return error;
    }
    // 如果手电筒打开，先关闭手电筒
    if ([self torchMode] == AVCaptureTorchModeOn) {
        [self setTorchMode:AVCaptureTorchModeOff];
    }
    return [self setFlashMode:flashMode];
}

- (id)setFlashMode:(AVCaptureFlashMode)flashMode{
    AVCaptureDevice *device = [self activeCamera];
    if ([device isFlashModeSupported:flashMode]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.flashMode = flashMode;
            [device unlockForConfiguration];
            _currentflashMode = flashMode;
        }
        return error;
    }
    return nil;
}

#pragma mark - -手电筒
-(void)torchLightAction:(CCCameraView *)cameraView succ:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error =  [self changeTorch:[self torchMode] == AVCaptureTorchModeOn?AVCaptureTorchModeOff:AVCaptureTorchModeOn];
    error?!fail?:fail(error):!succ?:succ();
}

- (BOOL)cameraHasTorch {
    return [[self activeCamera] hasTorch];
}

- (AVCaptureTorchMode)torchMode {
    return [[self activeCamera] torchMode];
}

- (id)changeTorch:(AVCaptureTorchMode)torchMode{
    if (![self cameraHasTorch]) {
        NSDictionary *desc = @{NSLocalizedDescriptionKey:@"不支持手电筒"};
        NSError *error = [NSError errorWithDomain:@"com.cc.camera" code:403 userInfo:desc];
        return error;
    }
    // 如果闪光灯打开，先关闭闪光灯
    if ([self flashMode] == AVCaptureFlashModeOn) {
        [self setFlashMode:AVCaptureFlashModeOff];
    }
    return [self setTorchMode:torchMode];
}

- (id)setTorchMode:(AVCaptureTorchMode)torchMode{
    AVCaptureDevice *device = [self activeCamera];
    if ([device isTorchModeSupported:torchMode]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.torchMode = torchMode;
            [device unlockForConfiguration];
        }
        return error;
    }
    return nil;
}

#pragma mark - -其它事件
// 取消拍照
- (void)cancelAction:(CCCameraView *)cameraView{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

// 转换拍摄类型
-(void)didChangeTypeAction:(CCCameraView *)cameraView type:(NSInteger)type{
    
}

// 拍照
- (void)takePhotoAction:(CCCameraView *)cameraView{
    [self takePictureImage];
}

// 开始录像
-(void)startRecordVideoAction:(CCCameraView *)cameraView{
    [self startRecording];
}

// 停止录像
-(void)stopRecordVideoAction:(CCCameraView *)cameraView{
    [self stopRecording];
}

#pragma mark - -Private methods
// 获取视频旋转矩阵
- (CGAffineTransform)transformFromCurrentVideoOrientationToOrientation:(AVCaptureVideoOrientation)orientation{
    CGFloat orientationAngleOffset = [self angleOffsetFromPortraitOrientationToOrientation:orientation];
    CGFloat videoOrientationAngleOffset = [self angleOffsetFromPortraitOrientationToOrientation:self.motionManager.videoOrientation];
    CGFloat angleOffset;
    if ([self activeCamera].position == AVCaptureDevicePositionBack) {
        angleOffset = orientationAngleOffset - videoOrientationAngleOffset;
    } else {
        angleOffset = videoOrientationAngleOffset - orientationAngleOffset + M_PI_2;
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleOffset);
    return transform;
}

// 获取视频旋转角度
- (CGFloat)angleOffsetFromPortraitOrientationToOrientation:(AVCaptureVideoOrientation)orientation{
    CGFloat angle = 0.0;
    switch (orientation){
        case AVCaptureVideoOrientationPortrait:
            angle = 0.0;
            break;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case AVCaptureVideoOrientationLandscapeRight:
            angle = -M_PI_2;
            break;
        case AVCaptureVideoOrientationLandscapeLeft:
            angle = M_PI_2;
            break;
        default:
            break;
    }
    return angle;
}

// 当前设备取向
- (AVCaptureVideoOrientation)currentVideoOrientation{
    AVCaptureVideoOrientation orientation;
    switch (self.motionManager.deviceOrientation) { 
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    return orientation;
}

// 移除文件
- (void)removeFile:(NSURL *)fileURL{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = fileURL.path;
    if ([fileManager fileExistsAtPath:filePath]){
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (!success){
            [self.view showError:error];
        } else {
            NSLog(@"删除视频文件成功");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
