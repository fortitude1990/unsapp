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

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createUI];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CreateUI

- (void)createUI{
    
    self.navigationController.navigationBar.hidden = YES;
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTintColor:[UIColor blackColor]];
    registerBtn.frame = CGRectMake(kRectWidth - 80, 20, 60, 42);
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
    
    [loginRadioView didSelected:^(NSInteger index) {
        
    }];
    
}




#pragma mark - Methods

#pragma mark - BtnActions

- (void)registerBtnAction{
    
}

@end
