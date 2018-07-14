//
//  SurprisedView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/13.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "SurprisedView.h"

@implementation SurprisedView

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
    [self addSubview:backView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"更多内容"]];
    [backView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(backView);
    }];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = @"更多惊喜，敬请期待!";
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textColor = KHexColor(0x6d6d72);
    [backView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(5);
        make.height.equalTo(@20);
        make.centerY.equalTo(imageView);
    }];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.left.equalTo(imageView.mas_left);
        make.right.equalTo(textLabel.mas_right);
    }];
}

@end
