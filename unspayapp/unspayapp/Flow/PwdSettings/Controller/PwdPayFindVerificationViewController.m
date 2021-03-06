//
//  PwdPayFindVerificationViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/30.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PwdPayFindVerificationViewController.h"
#import "TimerButton.h"
#import "NextButton.h"
#import "PwdPayFindIDViewController.h"
#import "Pay_Password_ViewController.h"

@interface PwdPayFindVerificationViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *verificationTF;
@property (strong, nonatomic) IBOutlet TimerButton *verificationBtn;

@property (strong, nonatomic) IBOutlet NextButton *nextBtn;
@end

@implementation PwdPayFindVerificationViewController

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
    
    self.navigationItem.title = @"找回支付密码";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    [self.verificationTF addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventEditingChanged];
    
    switch (self.type) {
        case FindPwdTypeMobile:
            
            break;
        case FindPwdTypeMail:
            self.titleLabel.text = @"已发送验证码到您绑定的邮箱:\n50332****@qq.com";
            break;
        default:
            break;
    }
    
}


#pragma mark - Methods

- (void)textFieldValueChange{
    
    if (self.verificationTF.text.length > 0) {
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
    
//    PwdPayFindIDViewController *IDVC = [[PwdPayFindIDViewController alloc] init];
//    [self.navigationController pushViewController:IDVC animated:YES];
    
    Pay_Password_ViewController *changeVC = [[Pay_Password_ViewController alloc] init];
    changeVC.passwordInputType = PasswordInputTypeSimpleChange;
    BaseNavController *naVC = [[BaseNavController alloc] initWithRootViewController:changeVC];
    [self presentViewController:naVC animated:YES completion:^{
        
    }];
    
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

@end
