//
//  LoginRadioView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/10.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "LoginRadioView.h"
#import "LoginRadioItemView.h"

@interface LoginRadioView()

@property (nonatomic, copy)  void(^complete)(NSInteger index);

@end;

@implementation LoginRadioView

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
    
    [self.superview layoutIfNeeded];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = KHexColor(0xb6b6b8);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@(kAutoScaleNormal(10)));
        make.bottom.equalTo(@(kAutoScaleNormal(-10)));
        make.width.equalTo(@0.5);
    }];
    
    LoginRadioItemView *oneItem = [[LoginRadioItemView alloc] init];
    oneItem.title = @"账号密码登录";
    [self addSubview:oneItem];
    [oneItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(@0);
        make.right.equalTo(line.mas_left);
    }];
    
    LoginRadioItemView *twoItem = [[LoginRadioItemView alloc] init];
    twoItem.title = @"手机验证码登录";
    [self addSubview:twoItem];
    [twoItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(@0);
        make.left.equalTo(line.mas_right);
    }];
    
    oneItem.loginRadioItemStatus = LoginRadioItemStatusSelected;
    
    [oneItem tapAction:^{
        
        if (oneItem.loginRadioItemStatus == LoginRadioItemStatusNoneSelect) {
            oneItem.loginRadioItemStatus = LoginRadioItemStatusSelected;
            twoItem.loginRadioItemStatus = LoginRadioItemStatusNoneSelect;
            _complete(0);
        }
        
        
        
    }];
    
    [twoItem tapAction:^{
        
        if (twoItem.loginRadioItemStatus == LoginRadioItemStatusNoneSelect) {
            twoItem.loginRadioItemStatus = LoginRadioItemStatusSelected;
            oneItem.loginRadioItemStatus = LoginRadioItemStatusNoneSelect;
            _complete(1);
        }
        
    }];
    
}

- (void)didSelected:(void (^)(NSInteger))complete{
    _complete = complete;
}

@end
