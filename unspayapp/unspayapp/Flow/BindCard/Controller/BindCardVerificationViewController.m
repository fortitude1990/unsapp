//
//  BindCardVerificationViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BindCardVerificationViewController.h"
#import "AuthItem.h"
#import "TimerButton.h"
#import "NextButton.h"

@interface BindCardVerificationViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet AuthItem *mobileItem;
@property (strong, nonatomic) IBOutlet UITextField *verificationTF;
@property (strong, nonatomic) IBOutlet TimerButton *verificationBtn;
@property (strong, nonatomic) IBOutlet UILabel *verificationTitleLabel;
@property (strong, nonatomic) IBOutlet NextButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIView *verificationItem;

@end

@implementation BindCardVerificationViewController

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

- (void)createUI{
    
    self.navigationItem.title = @"添加银行卡";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.verificationTitleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    self.verificationTF.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    self.verificationTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.verificationTF.delegate = self;
    self.mobileItem.titleLabel.text = @"预留手机号";
    self.mobileItem.textField.textAlignment = NSTextAlignmentLeft;
    self.mobileItem.textField.delegate = self;
    self.mobileItem.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [self.nextBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    
    [self.mobileItem.textField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventEditingChanged];
    [self.verificationTF addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventEditingChanged];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = KHexColor(0xd9d9d9);
    [self.verificationItem addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = KHexColor(0xd9d9d9);
    [self.verificationItem addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
}

#pragma mark - Methods

- (void)textFieldValueChange{
    
    if (self.mobileItem.textField.text.length > 0 && self.verificationTF.text.length > 0) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
    
}

#pragma mark - BtnActions

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)verificationBtnAction:(id)sender {
    
    [self.verificationBtn startTimerTotalTime:60 doningTintColor:KHexColor(0x6d6d72) doingBackgroundColor:nil unit:@"s"];
    
}
- (IBAction)nextBtnAction:(id)sender {
    
    
}
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.mobileItem.textField) {
        [self.verificationTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    
    return YES;
}

@end
