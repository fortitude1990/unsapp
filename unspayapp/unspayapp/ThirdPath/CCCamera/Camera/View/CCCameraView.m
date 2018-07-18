//
//  CCCameraView.m
//  CCCamera
//
//  Created by 佰道聚合 on 2017/7/5.
//  Copyright © 2017年 cyd. All rights reserved.
//

#import "CCCameraView.h"
#import "UIView+CCHUD.h"
#import "UIView+CCAdditions.h"

@interface CCCameraView()

@property(nonatomic, assign) NSInteger type; // 1：拍照 2：视频
@property(nonatomic, strong) CCVideoPreview *previewView;
@property(nonatomic, strong) UIView *topView;      // 上面的bar
@property(nonatomic, strong) UIView *bottomView;   // 下面的bar
@property(nonatomic, strong) UIView *focusView;    // 聚焦动画view
@property(nonatomic, strong) UIView *exposureView; // 曝光动画view

@property(nonatomic, strong) UIButton *torchBtn;
@property(nonatomic, strong) UIButton *flashBtn;
@property(nonatomic, strong) UIButton *photoBtn;

@end

@implementation CCCameraView

-(instancetype)initWithFrame:(CGRect)frame
{
    NSAssert(frame.size.height>164 || frame.size.width>374, @"相机视图的高不小于164，宽不小于375");
    self = [super initWithFrame:frame];
    if (self) {
        _type = 1;
        [self setupUI];
    }
    return self;
}

-(UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 64)];
//        _topView.backgroundColor = [UIColor blackColor];
    }
    return _topView;
}

-(UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-100, self.width, 100)];
        _bottomView.backgroundColor = [UIColor blackColor];
    }
    return _bottomView;
}

-(UIView *)focusView{
    if (_focusView == nil) {
        _focusView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150, 150.0f)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.layer.borderColor = [UIColor blueColor].CGColor;
        _focusView.layer.borderWidth = 5.0f;
        _focusView.hidden = YES;
    }
    return _focusView;
}

-(UIView *)exposureView{
    if (_exposureView == nil) {
        _exposureView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150, 150.0f)];
        _exposureView.backgroundColor = [UIColor clearColor];
        _exposureView.layer.borderColor = [UIColor purpleColor].CGColor;
        _exposureView.layer.borderWidth = 5.0f;
        _exposureView.hidden = YES;
    }
    return _exposureView;
}

-(void)setupUI{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    
    // 取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [cancelButton setImage:[UIImage imageNamed:@"返回-白"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton sizeToFit];
    cancelButton.frame = CGRectMake(0, 20, 50, 44);
    [self.topView addSubview:cancelButton];
    
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"拍摄身份证";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.font = [UIFont systemFontOfSize:17];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.frame = CGRectMake( (self.width - 200) / 2.0, 20, 200, 44);
    [self.topView addSubview:topLabel];
    
    self.previewView = [[CCVideoPreview alloc]initWithFrame:CGRectMake(15,  (self.height - (self.width - 15 * 2) * 392 / 670.0) / 2.0, self.width - 15 * 2, (self.width - 15 * 2) * 392 / 670.0)];
    self.previewView.layer.cornerRadius = 15;
    self.previewView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.previewView.layer.borderWidth = 1;
    self.previewView.clipsToBounds = YES;
    
    /*
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor whiteColor].CGColor;
    border.fillColor = [UIColor clearColor].CGColor;
    border.path = [UIBezierPath bezierPathWithRect:self.previewView.bounds].CGPath;
    border.frame = self.previewView.bounds;
    border.lineWidth = 1;
    border.cornerRadius = self.previewView.layer.cornerRadius;
    border.lineDashPattern = @[@4,@2];
    [self.previewView.layer addSublayer:border];
   */
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.previewView addGestureRecognizer:tap];
    [self.previewView addGestureRecognizer:doubleTap];
    [tap requireGestureRecognizerToFail:doubleTap];
    
    [self addSubview:self.previewView];
    [self addSubview:self.topView];
    [self.previewView addSubview:self.focusView];
    [self.previewView addSubview:self.exposureView];
    
    

    
    
    UIView *oneBV = [[UIView alloc] init];
    oneBV.frame = CGRectMake(0, CGRectGetMaxY(self.previewView.frame) + kAutoScaleNormal(37.9), self.width, self.height - CGRectGetMaxY(self.previewView.frame) - kAutoScaleNormal(37.9));
//    oneBV.backgroundColor = KHexColor(0x4a4a4a);
    [self addSubview:oneBV];
    
    NSString *text = @"将身份证正面置于此区域，拍摄身份证";
    UILabel *warningLabel = [[UILabel alloc] init];
    warningLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(32)];
    warningLabel.numberOfLines = 0;
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.textColor = [UIColor whiteColor];
    warningLabel.frame = CGRectMake(kAutoScaleNormal(30), kAutoScaleNormal(15), self.width -kAutoScaleNormal(60), [self heightOfWarningLabel:text]);
    warningLabel.text = text;
    [oneBV addSubview:warningLabel];
    
    
    // 拍照
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"shoot"]  forState:UIControlStateNormal];
    [photoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    [photoButton sizeToFit];
    photoButton.frame = CGRectMake((CGRectGetWidth(oneBV.frame) - kAutoScaleNormal(130)) / 2.0, CGRectGetHeight(oneBV.frame) - kAutoScaleNormal(220), kAutoScaleNormal(130), kAutoScaleNormal(130));
    [oneBV addSubview:photoButton];
    
    
    /*
    // 转换前后摄像头
    UIButton *switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchCameraButton setBackgroundImage:[UIImage imageNamed:@"互换"]  forState:UIControlStateNormal];
    [switchCameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [switchCameraButton addTarget:self action:@selector(switchCameraClick:) forControlEvents:UIControlEventTouchUpInside];
    [switchCameraButton sizeToFit];
    [oneBV addSubview:switchCameraButton];
    switchCameraButton.frame = CGRectMake(0, 0, kAutoScaleNormal(36), kAutoScaleNormal(28));
    switchCameraButton.center = CGPointMake(CGRectGetWidth(oneBV.frame) - kAutoScaleNormal(30) - CGRectGetWidth(switchCameraButton.frame) / 2.0, photoButton.center.y);
   */
    
    
    /*
    // 照片类型
    UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [typeButton setTitle:@"[照片]" forState:UIControlStateNormal];
    [typeButton setTitle:@"[视频]" forState:UIControlStateSelected];
    [typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [typeButton addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    [typeButton sizeToFit];
    typeButton.center = CGPointMake(_bottomView.width-60, _bottomView.height/2);
    [self.bottomView addSubview:typeButton];
    

    
    // 补光
    UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lightButton setTitle:@"补光" forState:UIControlStateNormal];
    [lightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lightButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [lightButton addTarget:self action:@selector(torchClick:) forControlEvents:UIControlEventTouchUpInside];
    [lightButton sizeToFit];
    lightButton.center = CGPointMake(lightButton.width/2 + switchCameraButton.right+10, _topView.height/2);
    [self.topView addSubview:lightButton];
    _torchBtn = lightButton;
    
    // 闪光灯
    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashButton setTitle:@"闪光灯" forState:UIControlStateNormal];
    [flashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [flashButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [flashButton addTarget:self action:@selector(flashClick:) forControlEvents:UIControlEventTouchUpInside];
    [flashButton sizeToFit];
    flashButton.center = CGPointMake(flashButton.width/2 + lightButton.right+10, _topView.height/2);
    [self.topView addSubview:flashButton];
    _flashBtn = flashButton;
    
    // 重置对焦、曝光
    UIButton *focusAndExposureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [focusAndExposureButton setTitle:@"自动聚焦/曝光" forState:UIControlStateNormal];
    [focusAndExposureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [focusAndExposureButton addTarget:self action:@selector(focusAndExposureClick:) forControlEvents:UIControlEventTouchUpInside];
    [focusAndExposureButton sizeToFit];
    focusAndExposureButton.center = CGPointMake(focusAndExposureButton.width/2 + flashButton.right+10, _topView.height/2);
    [self.topView addSubview:focusAndExposureButton];
     */
}

#pragma mark - Action

- (CGFloat)heightOfWarningLabel:(NSString *)text{
    return [text boundingRectWithSize:CGSizeMake(self.width - kAutoScaleNormal(60), 0) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kAutoScaleNormal(14)]} context:nil].size.height;
}


#pragma mark - others

-(void)changeTorch:(BOOL)on{
    _torchBtn.selected = on;
}

-(void)changeFlash:(BOOL)on{
    _flashBtn.selected = on;
}

// 聚焦
-(void)tapAction:(UIGestureRecognizer *)tap{
    if ([_delegate respondsToSelector:@selector(focusAction:point:succ:fail:)]) {
        CGPoint point = [tap locationInView:self.previewView];
        [self runFocusAnimation:self.focusView point:point];
        [_delegate focusAction:self point:[self.previewView captureDevicePointForPoint:point] succ:nil fail:^(NSError *error) {
            [self showError:error];
        }];
    }
}

// 曝光
-(void)doubleTapAction:(UIGestureRecognizer *)tap{
    if ([_delegate respondsToSelector:@selector(exposAction:point:succ:fail:)]) {
        CGPoint point = [tap locationInView:self.previewView];
        [self runFocusAnimation:self.exposureView point:point];
        [_delegate exposAction:self point:[self.previewView captureDevicePointForPoint:point] succ:nil fail:^(NSError *error) {
            [self showError:error];
        }];
    }
}

// 拍照
-(void)takePicture:(UIButton *)btn{
    if (self.type == 1) {
        if ([_delegate respondsToSelector:@selector(takePhotoAction:)]) {
            [_delegate takePhotoAction:self];
        }
    } else {
        if (btn.selected == YES) {
            // 结束
            btn.selected = NO;
            [_photoBtn setTitle:@"开始" forState:UIControlStateNormal];
            if ([_delegate respondsToSelector:@selector(stopRecordVideoAction:)]) {
                [_delegate stopRecordVideoAction:self];
            }
        } else {
            // 开始
            btn.selected = YES;
            [_photoBtn setTitle:@"结束" forState:UIControlStateNormal];
            if ([_delegate respondsToSelector:@selector(startRecordVideoAction:)]) {
                [_delegate startRecordVideoAction:self];
            }
        }
    }
}

// 取消
-(void)cancel:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(cancelAction:)]) {
        [_delegate cancelAction:self];
    }
}

// 转换拍摄类型
-(void)changeType:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.type = self.type == 1?2:1;
    if (self.type == 1) {
        [_photoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    } else {
        [_photoBtn setTitle:@"开始" forState:UIControlStateNormal];
    }
    if ([_delegate respondsToSelector:@selector(didChangeTypeAction:type:)]) {
        [_delegate didChangeTypeAction:self type:self.type == 1?2:1];
    }
}

// 转换前后摄像头
-(void)switchCameraClick:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(swicthCameraAction:succ:fail:)]) {
        [_delegate swicthCameraAction:self succ:nil fail:^(NSError *error) {
            [self showError:error];
        }];
    }
}

// 手电筒
-(void)torchClick:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(torchLightAction:succ:fail:)]) {
        [_delegate torchLightAction:self succ:^{
            _flashBtn.selected = NO;
            _torchBtn.selected = !_torchBtn.selected;
        } fail:^(NSError *error) {
            [self showError:error];
        }];
    }
}

// 闪光灯
-(void)flashClick:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(flashLightAction:succ:fail:)]) {
        [_delegate flashLightAction:self succ:^{
            _flashBtn.selected = !_flashBtn.selected;
            _torchBtn.selected = NO;
        } fail:^(NSError *error) {
            [self showError:error];
        }];
    }
}

// 自动聚焦和曝光
-(void)focusAndExposureClick:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(autoFocusAndExposureAction:succ:fail:)]) {
        [_delegate autoFocusAndExposureAction:self succ:^{
            [self showAutoDismissHUD:@"自动聚焦曝光设置成功"];
        } fail:^(NSError *error) {
            [self showError:error];
        }];
    }
}

#pragma mark - Private methods
// 聚焦、曝光动画
-(void)runFocusAnimation:(UIView *)view point:(CGPoint)point{
    view.center = point;
    view.hidden = NO;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    } completion:^(BOOL complete) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            view.hidden = YES;
            view.transform = CGAffineTransformIdentity;
        });
    }];
}

// 自动聚焦、曝光动画
- (void)runResetAnimation {
    self.focusView.center = CGPointMake(self.previewView.width/2, self.previewView.height/2);
    self.exposureView.center = CGPointMake(self.previewView.width/2, self.previewView.height/2);;
    self.exposureView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    self.focusView.hidden = NO;
    self.focusView.hidden = NO;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.focusView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
        self.exposureView.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1.0);
    } completion:^(BOOL complete) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.focusView.hidden = YES;
            self.exposureView.hidden = YES;
            self.focusView.transform = CGAffineTransformIdentity;
            self.exposureView.transform = CGAffineTransformIdentity;
        });
    }];
}

@end
