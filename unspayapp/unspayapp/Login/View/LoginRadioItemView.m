//
//  LoginRadioItemView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/10.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "LoginRadioItemView.h"

@interface LoginRadioItemView()
{
    UIButton *_btn;
    UIView *_lineView;
    void (^_complete)();
}

@end

@implementation LoginRadioItemView

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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:kAutoScaleNormal(32)]];
    [btn setTitleColor:KHexColor(0xb6b6b8) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.bottom.equalTo(@(-1));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = KHexColor(0x0068b7);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kAutoScaleNormal(50)));
        make.right.equalTo(@(kAutoScaleNormal(-50)));
        make.top.equalTo(btn.mas_bottom);
        make.height.equalTo(@1);
    }];
    lineView.hidden = YES;
    
    _btn = btn;
    _lineView = lineView;
}

- (void)tapAction:(void (^)())complete{
    if (complete) {
        _complete = complete;
    }
}

- (void)btnAction{
    
    _complete();
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [_btn setTitle:title forState:UIControlStateNormal];
}

- (void)setLoginRadioItemStatus:(LoginRadioItemStatus)loginRadioItemStatus{
    _loginRadioItemStatus = loginRadioItemStatus;
    switch (loginRadioItemStatus) {
            
        case LoginRadioItemStatusSelected:
            _lineView.hidden = NO;
            [_btn setTitleColor:KHexColor(0x0068b7) forState:UIControlStateNormal];
            break;
        case LoginRadioItemStatusNoneSelect:
            _lineView.hidden = YES;
            [_btn setTitleColor:KHexColor(0xb6b6b8) forState:UIControlStateNormal];
            break;
        default:
            break;
            
    }
}

@end
