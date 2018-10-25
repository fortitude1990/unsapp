//
//  RegisterViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/11.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RegisterViewController.h"
#import "RadioBtn.h"
#import "NextButton.h"
#import "TimerButton.h"
#import "ServeForTextField.h"
#import "RegisterSuccessViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *mobileTF;
@property (strong, nonatomic) IBOutlet UITextField *verificationTF;
@property (strong, nonatomic) IBOutlet TimerButton *verificationBtn;
@property (strong, nonatomic) IBOutlet UITextField *pwdTF;
@property (strong, nonatomic) IBOutlet UITextField *onceAgainTF;
@property (strong, nonatomic) IBOutlet RadioBtn *checkBox;
@property (strong, nonatomic) IBOutlet UILabel *protocolLabel;
@property (strong, nonatomic) IBOutlet NextButton *nextBtn;

@property (strong, nonatomic) ServeForTextField *server;

@end

@implementation RegisterViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
    
    self.server = [[ServeForTextField alloc] init];
    [self.server startServeFor:self.view];
    
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
    
    self.navigationController.navigationBar.hidden = NO;

    self.navigationItem.title = @"注册";
    
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.verificationBtn.layer.cornerRadius = 16.5;
    self.verificationBtn.layer.borderColor = KHexColor(0x0068b7).CGColor;
    self.verificationBtn.layer.borderWidth = 0.5;
    self.verificationBtn.clipsToBounds = YES;
    
    self.nextBtn.layer.cornerRadius = 22;
    self.nextBtn.clipsToBounds = YES;
    [self.nextBtn setTitle:@"注册" forState:UIControlStateNormal];
    
    self.protocolLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolBtnAction)];
    [self.protocolLabel addGestureRecognizer:tapGesture];
    
    self.mobileTF.delegate = self;
    self.verificationTF.delegate = self;
    self.pwdTF.delegate = self;
    self.onceAgainTF.delegate = self;
    
}

#pragma mark - Methods

- (IBAction)textFieldValueChange:(id)sender {
    
    if (self.pwdTF.text.length > 0 && self.verificationTF.text.length > 0 && self.pwdTF.text.length > 0 && self.onceAgainTF.text.length > 0) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
    
}


#pragma mark - BtnActions

- (IBAction)verificationBtnAction:(id)sender {
    
    [self.verificationBtn startTimerTotalTime:60 doningTintColor:KHexColor(0x6d6d72) doingBackgroundColor:nil unit:@"s"];
    
}

- (IBAction)nextBtnAction:(id)sender {
    
    
    if ([self.pwdTF.text isEqualToString:self.onceAgainTF.text]) {
        [self networking];
    }else{
        [PopupAction alertMsg:@"密码再次输入不正确" of:self];
    }
    
    

    
    
}


- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)protocolBtnAction{
    
}

#pragma mark - Networking

- (void)networking{
    
    NSDictionary *params = @{@"tel" : self.mobileTF.text,
                             @"pwd" : self.pwdTF.text
                             };
    [Networking networkingWithHTTPOfPostTo:kRegisterUrl params:params backData:^(NSData *data) {
        
        if (data.length == 0) {
            [PopupAction alertMsg:@"网络异常" of:self];
            return ;
        }
        
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *rspCode = jsonDic[@"rspCode"];
        
        if ([rspCode isEqualToString:@"0000"]) {
            
                RegisterSuccessViewController *successVC = [[RegisterSuccessViewController alloc] init];
                [self.navigationController pushViewController:successVC animated:YES];
            
        }else{
            NSString *rspMsg = jsonDic[@"rspMsg"];
            NSLog(@"%@", rspMsg);
            [PopupAction alertMsg:rspMsg of:self];
        }
                                 
        
        
    }];
    
    
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.server currentTextField:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (![self.server isLengthOf:textField range:range string:string length:@11]) {
        return NO;
    }
   
    if (![self.server isUnicharFrom:48 to:57 of:string]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.mobileTF) {
        [self.verificationTF becomeFirstResponder];
    }else if (textField == self.verificationTF){
        [self.pwdTF becomeFirstResponder];
    }else if (textField == self.pwdTF){
        [self.onceAgainTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    return YES;
}

@end
