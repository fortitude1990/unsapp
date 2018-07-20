//
//  NoneRechargeRecordView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "NoneRechargeRecordView.h"

@implementation NoneRechargeRecordView

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


-(void)createUI{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"暂无记录"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kAutoScaleNormal(360)));
        make.width.equalTo(@(kAutoScaleNormal(605.4)));
        make.centerX.equalTo(self);
        make.top.equalTo(@(kAutoScaleNormal(188)));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无充值历史记录";
    label.textColor = KHexColor(0x6d6d72);
    label.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(imageView.mas_bottom).offset(15);
        make.height.equalTo(@20);
    }];
    
}

@end
