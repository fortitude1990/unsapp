//
//  UploadIdCardViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "UploadIdCardViewController.h"
#import "CCCameraViewController.h"
#import "AuthItem.h"
#import "NextButton.h"
#import "LiDatePicker.h"
#import "RealNameAuthStatusViewController.h"

@interface UploadIdCardViewController ()<UITextFieldDelegate, LiDatePickerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *IDPhotoTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *positiveBtn;
@property (strong, nonatomic) IBOutlet UIButton *reverseBtn;
@property (strong, nonatomic) IBOutlet UIView *oneView;
@property (strong, nonatomic) IBOutlet AuthItem *twoView;
@property (strong, nonatomic) IBOutlet NextButton *nextBtn;

@property (nonatomic, strong)UIImage *positiveImage;
@property (nonatomic, strong)UIImage *reverseImage;


@end

@implementation UploadIdCardViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
    
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

#pragma mark - CreateUI

- (void)createUI{
    
    self.navigationItem.title = @"上传身份证";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = KHexColor(0xd9d9d9);
    [self.oneView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = KHexColor(0xd9d9d9);
    [self.oneView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    self.IDPhotoTitleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    self.positiveBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.reverseBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.positiveBtn.layer.cornerRadius = kAutoScaleNormal(8);
    self.positiveBtn.clipsToBounds = YES;
    self.reverseBtn.layer.cornerRadius = kAutoScaleNormal(8);
    self.reverseBtn.clipsToBounds = YES;
    
    self.twoView.titleLabel.text = @"有效期";
    self.twoView.textField.placeholder = @"点击设置";
    self.twoView.textField.delegate = self;
    
    [self.nextBtn setTitle:@"确认并提交" forState:UIControlStateNormal];
    
}

#pragma mark - BtnActions

- (IBAction)nextBtnAction:(id)sender {
    
    RealNameAuthStatusViewController *statusVC = [[RealNameAuthStatusViewController alloc] init];
    statusVC.quitType = QuitTypeDismiss;
    [self.navigationController pushViewController:statusVC animated:YES];
    
}

- (IBAction)longTimeSettingBtnAction:(id)sender {
    
    self.twoView.textField.text = @"长期";
    [self judgeNextBtn];
}


- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)postitiveBtnAction:(id)sender {
    
    CCCameraViewController *cameraVC = [[CCCameraViewController alloc] init];
    [cameraVC callBack:^(UIImage *image,CGRect frame) {

        self.positiveImage = image;
        [self.positiveBtn setImage:image forState:UIControlStateNormal];
        [self judgeNextBtn];
        
    }];
    [self presentViewController:cameraVC animated:YES completion:nil];
    
    
}
- (IBAction)reverseBtnAction:(id)sender {
    
    CCCameraViewController *cameraVC = [[CCCameraViewController alloc] init];
    [cameraVC callBack:^(UIImage *image,CGRect frame) {
        
        self.reverseImage = image;
        [self.reverseBtn setImage:image forState:UIControlStateNormal];
        [self judgeNextBtn];
        
    }];
    [self presentViewController:cameraVC animated:YES completion:nil];
    
}

#pragma mark - Methods

- (void)judgeNextBtn{
    if (self.positiveImage && self.reverseImage && self.twoView.textField.text.length > 0) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
}

- (NSArray *)elementsArray{
    return @[@[@"5年",
             @"10年",
             @"15年",
             @"20年",
             @"25年",
             @"30年"]];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == self.twoView.textField) {
        
        LiDatePicker *datePicker = [[LiDatePicker alloc] init];
        datePicker.delegate = self;
        datePicker.type = PickerTypeCustom;
        datePicker.elementsArray = [self elementsArray];
        datePicker.hiddenCancel = YES;
        datePicker.title = @"有效期";
        [datePicker show];
        
    }
    
    return NO;
}

#pragma mark - LiDatePickerDelegate

- (void)datePicker:(LiDatePicker *)datePicker date:(NSString *)dateString{
    
    self.twoView.textField.text = dateString;
    [self judgeNextBtn];

}

@end
