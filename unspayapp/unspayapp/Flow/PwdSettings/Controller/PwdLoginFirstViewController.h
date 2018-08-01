//
//  PwdLoginFirstViewController.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/30.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,PwdSettingType) {
    PwdSettingTypeLogin,
    PwdSettingTypeLoginChange,
    PwdSettingTypeGesture,
};

@interface PwdLoginFirstViewController : BaseViewController

@property (nonatomic, assign)PwdSettingType pwdSettingType;

@end
