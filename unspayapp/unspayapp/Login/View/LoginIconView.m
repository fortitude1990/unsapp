//
//  LoginIconView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/10.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "LoginIconView.h"

@implementation LoginIconView

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
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"个人版";
    label.font = [UIFont systemFontOfSize:kAutoScaleNormal(24)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = KHexColor(0x595959);
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 5;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.bottom.equalTo(@(kAutoScaleNormal(-15)));
        make.width.equalTo(@(kAutoScaleNormal(80)));
        make.height.equalTo(@(kAutoScaleNormal(33)));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"登录页logo-版本号logo"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.bottom.equalTo(@0);
        make.right.equalTo(label.mas_left).offset(kAutoScaleNormal(-5));
    }];
    
    
}

@end
