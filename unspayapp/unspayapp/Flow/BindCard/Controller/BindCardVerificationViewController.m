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
#import "BankCard.h"

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
    self.mobileItem.textField.placeholder = @"请输入预留手机号码";
    
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
    
    [self networking];
}

- (void)networking{
    
    self.bankCard.bankAboutMobile = self.mobileItem.textField.text;
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    
    NSDictionary *params = @{@"accountId" : defaultMessage.accountId,
                             @"bankNo" : self.bankCard.bankNo,
                             @"bankName" : self.bankCard.bankName,
                             @"bankCode" : self.bankCard.bankCode,
                             @"bankAboutMobile" : self.bankCard.bankAboutMobile,
                             @"name" : self.bankCard.name,
                             @"cardType" : self.bankCard.cardType
                             };
    
    [ProgressHUB show];
    [Networking networkingWithHTTPOfPostTo:kAddBankCardUrl params:params backData:^(NSData *data) {
        
        [ProgressHUB dismiss];
        
        if (data.length == 0) {
            [PopupAction alertMsg:@"无法连接服务器，请稍后重试" of:self];
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *rspCode = jsonDic[@"rspCode"];
        
        if ([rspCode isEqualToString:@"0000"]) {
            
            [[PopupAction defaultPopupAction] popupWithTitle:@"温馨提示" message:@"银行卡绑定成功" ok:@"确定" cancel:nil okAction:^{
                
                [self dismissViewControllerAnimated:YES completion:^{
                    BaseNavController *navC = (BaseNavController *)self.navigationController;
                    if (navC.myHandler) {
                        ReturnBlock callBack = (ReturnBlock)navC.myHandler;
                        callBack(YES, @"成功", self.bankCard);
                    }
                }];
                
            } cancelAction:nil of:self];
            

            
        }else{
            NSString *rspMsg = jsonDic[@"rspMsg"];
            NSLog(@"%@", rspMsg);
            [PopupAction alertMsg:rspMsg of:self];
        }
        
        
    }];
    
    
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
