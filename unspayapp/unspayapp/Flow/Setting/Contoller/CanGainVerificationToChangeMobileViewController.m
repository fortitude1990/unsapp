//
//  CanGainVerificationToChangeMobileViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/8/10.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "CanGainVerificationToChangeMobileViewController.h"
#import "AuthItem.h"
#import "TimerButton.h"
#import "NextButton.h"
#import "ChangeMobileOrEmailGainVerificaitonViewController.h"


@interface CanGainVerificationToChangeMobileViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet AuthItem *oneItem;
@property (strong, nonatomic) IBOutlet AuthItem *twoItem;
@property (strong, nonatomic) IBOutlet UITextField *verificationTF;
@property (strong, nonatomic) IBOutlet TimerButton *verificationBtn;
@property (strong, nonatomic) IBOutlet NextButton *nextBtn;

@end

@implementation CanGainVerificationToChangeMobileViewController

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
    
    self.navigationItem.title = @"换绑手机";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.oneItem.titleLabel.text = @"原手机号";
    self.oneItem.textField.text = @"18531240875";
    self.oneItem.textField.userInteractionEnabled = NO;
    
    self.verificationTF.placeholder = @"请输入验证码";
    self.verificationTF.delegate = self;
    
    self.twoItem.titleLabel.text = @"新手机号";
    self.twoItem.textField.placeholder = @"请输入新手机号";
    self.twoItem.textField.delegate = self;
    self.twoItem.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    
    [self.verificationTF addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventEditingChanged];
    [self.twoItem.textField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventEditingChanged];

    
}

#pragma mark - Methods

- (void)textFieldValueChange{
    
    if (self.oneItem.textField.text.length > 0 && self.verificationTF.text.length > 0 && self.twoItem.textField.text.length > 0) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
    
}



#pragma mark - BtnActions

- (IBAction)nextBtnAction:(id)sender {
    
    ChangeMobileOrEmailGainVerificaitonViewController *changeVC = [[ChangeMobileOrEmailGainVerificaitonViewController alloc] init];
    [self.navigationController pushViewController:changeVC animated:YES];
    
}


- (IBAction)verificationBtnAction:(id)sender {
    
    [self.verificationBtn startTimerTotalTime:60 doningTintColor:KHexColor(0x6d6d72) doingBackgroundColor:nil unit:@"s"];
    
}

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    return YES;
}

@end
