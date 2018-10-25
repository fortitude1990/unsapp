//
//  ViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/10.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginIconView.h"
#import "LoginRadioView.h"
#import "PWDLoginView.h"
#import "ServeForTextField.h"
#import "RegisterViewController.h"
#import "TabViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)PWDLoginView *pwdLoginView;

@property (nonatomic, strong)ServeForTextField *server;

@end

@implementation LoginViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createUI];
    
    self.server = [[ServeForTextField alloc] init];
    [self.server startServeFor:self.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - CreateUI

- (void)createUI{
    
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTintColor:[UIColor blackColor]];
    registerBtn.frame = CGRectMake(kRectWidth - 60 - kAutoScaleNormal(20), 20, 60, 42);
    [registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    LoginIconView *loginIconView = [[LoginIconView alloc] init];
    [self.view addSubview:loginIconView];
    [loginIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kAutoScaleNormal(164)));
        make.width.equalTo(@(kAutoScaleNormal(300)));
        make.height.equalTo(@(kAutoScaleNormal(100)));
        make.centerX.equalTo(self.view);
    }];
    
    LoginRadioView *loginRadioView = [[LoginRadioView alloc] init];
    [self.view addSubview:loginRadioView];
    [loginRadioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.top.equalTo(loginIconView.mas_bottom).offset(kAutoScaleNormal(100));
        make.height.equalTo(@(kAutoScaleNormal(70)));
    }];
    

    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.text = @"www.unspay.com";
    bottomLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(28)];
    bottomLabel.textColor = KHexColor(0x323334);
    [self.view addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(kAutoScaleNormal(-30)));
        make.height.equalTo(@(kAutoScaleNormal(30)));
    }];
    
    PWDLoginView *pwdLoginView = [[PWDLoginView alloc] init];
    [self.view addSubview:pwdLoginView];
    [pwdLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(loginRadioView.mas_bottom).offset(kAutoScaleNormal(60));
        make.bottom.equalTo(bottomLabel.mas_top);
    }];
    
    
    self.pwdLoginView = pwdLoginView;
    
    
    __weak typeof(self) _weakSelf = self;
    
    [loginRadioView didSelected:^(NSInteger index) {
        
        switch (index) {
            case 0:
                _weakSelf.pwdLoginView.loginType = LoginTypePwd;
                break;
            case 1:
                _weakSelf.pwdLoginView.loginType = LoginTypeVerification;
                break;
            default:
                break;
        }
        
    }];
    
    [self.pwdLoginView pwdLoginGainVerificationStart:^(BOOL flag, NSString *msg) {
        
    } gainVerificationEnd:^(BOOL flag, NSString *msg) {
        
    } start:^(BOOL flag, NSString *msg) {
        
        if (flag) {
            
        }else{
            [PopupAction alertMsg:msg of:self];
        }
        
        
    } end:^(BOOL flag, NSString *msg) {
        
        if (flag == YES) {
            TabViewController *tabVC = [[TabViewController alloc] init];
            [self presentViewController:tabVC animated:YES completion:^{
                
            }];
        }else{
            [PopupAction alertMsg:msg of:self];
        }
        
        
    } forgetPwd:^(BOOL flag, NSString *msg) {
        
    }];
    
    self.pwdLoginView.mobileTF.delegate = self;
    self.pwdLoginView.pwdTF.delegate = self;
    
}




#pragma mark - Methods

#pragma mark - BtnActions

- (void)registerBtnAction{
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

#pragma mark - Networking

- (void)networking{
    
    
    
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.server currentTextField:textField];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.pwdLoginView.mobileTF) {
        
        if (![self.server isUnicharFrom:48 to:57 of:string]) {
            return NO;
        }
        
        if (![self.server isLengthOf:textField range:range string:string length:@11]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.pwdLoginView.mobileTF) {
        [self.pwdLoginView.pwdTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    return YES;
}

@end
