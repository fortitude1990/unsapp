//
//  SecuritySettingsView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "SecuritySettingsView.h"
#import "SecuritySettingCollectionViewCell.h"
#import "GradientView.h"
#import "PwdLoginFirstViewController.h"
#import "PersonCenterViewController.h"
#import "Pay_Password_ViewController.h"
#import "PwdPayViewController.h"



@implementation SecuritySettingsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    backView.layer.shadowOffset = CGSizeMake(2, 2);
    backView.layer.shadowOpacity = 0.8;
    backView.layer.shadowRadius = 2;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.right.equalTo(@(-15));
        make.height.equalTo(backView.mas_width).multipliedBy(0.8);
    }];
    
    SecuritySettingCollectionViewCell *oneItem = [[SecuritySettingCollectionViewCell alloc] init];
    [backView addSubview:oneItem];
    [oneItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.width.equalTo(backView.mas_width).multipliedBy(0.5);
        make.height.equalTo(backView.mas_height).multipliedBy(0.5);
    }];
    
    SecuritySettingCollectionViewCell *twoItem = [[SecuritySettingCollectionViewCell alloc] init];
    [backView addSubview:twoItem];
    [twoItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(@0);
        make.width.equalTo(backView.mas_width).multipliedBy(0.5);
        make.height.equalTo(backView.mas_height).multipliedBy(0.5);
    }];
    
    SecuritySettingCollectionViewCell *threeItem = [[SecuritySettingCollectionViewCell alloc] init];
    [backView addSubview:threeItem];
    [threeItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@0);
        make.width.equalTo(backView.mas_width).multipliedBy(0.5);
        make.height.equalTo(backView.mas_height).multipliedBy(0.5);
    }];
    
    SecuritySettingItemModel *oneModel = [[SecuritySettingItemModel alloc] init];
    oneModel.itemImageName = @"登录密码设置";
    oneModel.title = @"登录密码设置";
    oneItem.dataSource = oneModel;
    
    SecuritySettingItemModel *twoModel = [[SecuritySettingItemModel alloc] init];
    twoModel.itemImageName = @"支付密码设置";
    twoModel.title = @"支付密码设置";
    twoItem.dataSource = twoModel;
    
    SecuritySettingItemModel *threeModel = [[SecuritySettingItemModel alloc] init];
    threeModel.itemImageName = @"手势密码设置";
    threeModel.title = @"手势密码设置";
    threeItem.dataSource = threeModel;
    
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginPwdSetting)];
    [oneItem addGestureRecognizer:oneTap];
    
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payPwdSetting)];
    [twoItem addGestureRecognizer:twoTap];
    
    UITapGestureRecognizer *threeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesturesPwdSetting)];
    [threeItem addGestureRecognizer:threeTap];
    
    GradientView *oneGradientView = [[GradientView alloc] init];
    [backView addSubview:oneGradientView];
    [oneGradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.top.equalTo(oneItem.mas_bottom).offset(-0.25);
    }];
    
    GradientView *twoGradientView = [[GradientView alloc] init];
    [backView addSubview:twoGradientView];
    [twoGradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneItem.mas_right).offset(-0.25);
        make.width.equalTo(@0.5);
        make.top.equalTo(@0);
        make.height.equalTo(backView.mas_height).multipliedBy(0.5);
    }];
    
    GradientView *threeGradientView = [[GradientView alloc] init];
    [backView addSubview:threeGradientView];
    [threeGradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneItem.mas_right).offset(-0.25);
        make.width.equalTo(@0.5);
        make.top.equalTo(twoGradientView.mas_bottom);
        make.height.equalTo(backView.mas_height).multipliedBy(0.5);
    }];
    
}

- (void)loginPwdSetting{
    
    PersonCenterViewController *myController = (PersonCenterViewController *)self.controller;
    PwdLoginFirstViewController *loginVC = [[PwdLoginFirstViewController alloc] init];
    myController.hidesBottomBarWhenPushed = YES;
    [self.controller.navigationController pushViewController:loginVC animated:YES];
    
}

- (void)payPwdSetting{
    
    //设置支付密码之前
    /*
    Pay_Password_ViewController *realVC = [[Pay_Password_ViewController alloc] init];
    realVC.passwordInputType = PasswordInputTypeSimpleSetting;
    BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:realVC];
    [self.controller presentViewController:navC animated:YES completion:^{
        
    }];
    */
    
    PersonCenterViewController *myController = (PersonCenterViewController *)self.controller;
    myController.hidesBottomBarWhenPushed = YES;

    PwdPayViewController *payVC = [[PwdPayViewController alloc] init];
    [self.controller.navigationController pushViewController:payVC animated:YES];
    
    
}
- (void)gesturesPwdSetting{
    
}

@end
