//
//  Pay_Password_ViewController.h
//  QuickPayment
//
//  Created by 李志敬 on 16/7/7.
//  Copyright © 2016年 李志敬. All rights reserved.
//

#import "BaseViewController.h"




typedef NS_ENUM(NSInteger, PasswordInputType) {
    
    PasswordInputTypeDefault,
    PasswordInputTypeSimpleSettingNoneBack, 
    PasswordInputTypeSimpleSetting,  //单纯的设置密码
    PasswordInputTypeCompoundSetting,  //复合的设置密码
    PasswordInputTypeSimpleChange,  //单纯的修改密码
    PasswordInputTypeCompoundChange,  //复合的修改密码
    
};


typedef void(^PasswordBackValue)(id backValue);


@interface Pay_Password_ViewController : BaseViewController

@property (nonatomic, assign)PasswordInputType passwordInputType;


@property (nonatomic, copy)PasswordBackValue backValue;


- (void)sendValue: (PasswordBackValue)backValue;

@end
