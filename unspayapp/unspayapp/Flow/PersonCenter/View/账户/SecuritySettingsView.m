//
//  SecuritySettingsView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "SecuritySettingsView.h"

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
        make.edges.equalTo(@10);
        make.right.equalTo(@(-15));
        make.height.equalTo(backView.mas_width).multipliedBy(0.8);
    }];
    
    
    
}

@end
