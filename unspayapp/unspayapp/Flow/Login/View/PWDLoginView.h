//
//  PWDLoginView.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/11.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PWDLoginViewBlock)(BOOL flag,NSString *msg);

typedef NS_ENUM(NSInteger,LoginType) {
    LoginTypePwd,
    LoginTypeVerification,
};

@interface PWDLoginView : UIView

@property (nonatomic, strong)UITextField *mobileTF;
@property (nonatomic, strong)UITextField *pwdTF;
@property (nonatomic, assign)LoginType loginType;


- (void)pwdLoginGainVerificationStart:(PWDLoginViewBlock)gainVerificationStart gainVerificationEnd:(PWDLoginViewBlock)gainVerificationEnd start:(PWDLoginViewBlock)start end:(PWDLoginViewBlock)end forgetPwd:(PWDLoginViewBlock)forget;

@end
