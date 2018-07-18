//
//  CCImagePreviewController.m
//  CCCamera
//
//  Created by wsk on 16/8/22.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "CCImagePreviewController.h"
#import "CCCameraViewController.h"

@interface CCImagePreviewController ()
{
    UIImage *_image;
    CGRect   _frame;
}

@property (nonatomic, strong)UIView *topView;
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;

@end

@implementation CCImagePreviewController

- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _image = image;
        _frame = frame;
    }
    return self;
}

- (CGFloat)width{
    return self.view.frame.size.width;
}

- (CGFloat)height{
    return self.view.frame.size.height;
}

- (instancetype)init{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Use -initWithImage: frame:" userInfo:nil];
}

+ (instancetype)new{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Use -initWithImage: frame:" userInfo:nil];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self initWithImage:nil frame:CGRectZero];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    return [self initWithImage:nil frame:CGRectZero];
}

-(UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 64)];
        //        _topView.backgroundColor = [UIColor blackColor];
    }
    return _topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:backView];
    
    [self.view addSubview:self.topView];
    
    // 取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"返回-白"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
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
    

    
    
    

    UIImageView *imageView = [[UIImageView alloc]initWithImage:_image];
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 1;
    imageView.layer.cornerRadius = kAutoScaleNormal(30);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = CGRectMake(15, (self.height - (self.width - 15 * 2) * 392 / 670.0) / 2.0, _frame.size.width, _frame.size.height);
    //    imageView.frame = CGRectMake(0, 0, _frame.size.width, 300);
    
    [self.view addSubview:imageView];
    
    
    
    
    
    UIView *oneBV = [[UIView alloc] init];
    oneBV.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + kAutoScaleNormal(37.9), self.width, self.height - CGRectGetMaxY(imageView.frame) - kAutoScaleNormal(37.9));
    //    oneBV.backgroundColor = KHexColor(0x4a4a4a);
    [self.view addSubview:oneBV];
    
    NSString *text = @"将身份证正面置于此区域，拍摄身份证";
    UILabel *warningLabel = [[UILabel alloc] init];
    warningLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(32)];
    warningLabel.numberOfLines = 0;
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.textColor = [UIColor whiteColor];
    warningLabel.frame = CGRectMake(kAutoScaleNormal(30), kAutoScaleNormal(15), self.width -kAutoScaleNormal(60), 30);
    warningLabel.text = text;
    [oneBV addSubview:warningLabel];
    
    
    // 拍照
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setTitle:@"重拍" forState:UIControlStateNormal];
    photoButton.titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(34)];
    [photoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [photoButton sizeToFit];
    photoButton.frame = CGRectMake(kAutoScaleNormal(40), CGRectGetHeight(oneBV.frame) - kAutoScaleNormal(141), kAutoScaleNormal(80), kAutoScaleNormal(51));
    [oneBV addSubview:photoButton];
    
    
    // 完成
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    completeButton.titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(34)];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(completeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [completeButton sizeToFit];
    completeButton.frame = CGRectMake(self.width - kAutoScaleNormal(40) - kAutoScaleNormal(80), CGRectGetHeight(oneBV.frame) - kAutoScaleNormal(141), kAutoScaleNormal(80), kAutoScaleNormal(51));
    [oneBV addSubview:completeButton];
    
    
}

- (void)completeBtnAction{
    
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.block) {
            self.block(YES, nil);
        }
    }];

    
}

- (void)callBack:(CommonBlock)callBack{
    if (callBack) {
        self.block =  callBack;
    }
}

- (void)takePicture{
    [self dismissViewControllerAnimated:NO completion:^{

    }];
}

- (void)cancel{
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.block) {
            self.block(NO, @"");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
