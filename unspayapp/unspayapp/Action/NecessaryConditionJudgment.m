//
//  NecessaryConditionJudgment.m
//  unspayapp
//
//  Created by 李志敬 on 2018/10/29.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "NecessaryConditionJudgment.h"
#import "RealNameAuthViewController.h"
#import "Pay_Password_ViewController.h"

@implementation NecessaryConditionJudgment

+ (void)promptAndDoRealName:(id)sender{
    
    [[PopupAction defaultPopupAction] popupWithTitle:@"温馨提示" message:@"您还没有进行实名认证，请进行实名认证" ok:@"再看看" cancel:@"去实名认证" okAction:nil cancelAction:^{
        [self toRealName:sender];
    } of:sender];
    
}


+ (void)toRealName:(id)sender{
    
    RealNameAuthViewController *realVC = [[RealNameAuthViewController alloc] init];
    BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:realVC];
    [sender presentViewController:navC animated:YES completion:^{
        
    }];
    
}


+ (BOOL)checkIsRealName{
    DefaultMessage *defaultMsg = [DefaultMessage shareMessage];
    if ([defaultMsg.baseMsg.isRealName isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}


+ (void)promptAndDoSetPayPwd:(id)sender{
    
    [[PopupAction defaultPopupAction] popupWithTitle:@"温馨提示" message:@"请设置支付密码" ok:@"再看看" cancel:@"设置" okAction:nil cancelAction:^{
        
        [self toSetPayPwd:sender];
        
    } of:sender];
    
}

+ (void)toSetPayPwd:(id)sender{
    
    Pay_Password_ViewController *realVC = [[Pay_Password_ViewController alloc] init];
    realVC.passwordInputType = PasswordInputTypeSimpleSetting;
    BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:realVC];
    [sender presentViewController:navC animated:YES completion:^{
        
    }];
    
    [realVC sendValue:^(BOOL flag, NSString *message) {
        [PopupAction alertMsg:message of:sender];
    }];
    
    
    
}


+ (BOOL)checkIsSetPayPwd{
    DefaultMessage *defaultMsg = [DefaultMessage shareMessage];
    if ([defaultMsg.baseMsg.isSetPayPwd isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}


@end
