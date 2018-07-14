//
//  ContactView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/13.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "ContactView.h"

@implementation ContactView

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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:KHexColor(0x0068b7) forState:UIControlStateNormal];
    [btn setTitle:@"客服热线：021-684325" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(28)];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.height.equalTo(@(kAutoScaleNormal(42)));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

- (void)btnAction{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:021-684325"]];
}

@end
