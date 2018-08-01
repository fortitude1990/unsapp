//
//  PwdPayFindVerificationViewController.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/30.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, FindPwdType) {
    FindPwdTypeMobile,
    FindPwdTypeMail
};

@interface PwdPayFindVerificationViewController : BaseViewController

@property (nonatomic, assign)FindPwdType type;

@end
