//
//  ShadowView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/27.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "ShadowView.h"

@interface ShadowView()
{
    UIView *_leftView;
    UIView *_rightView;
}
@end

@implementation ShadowView

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
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    
    
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor whiteColor];
    leftView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    leftView.layer.shadowOffset = CGSizeMake(-0, -0);
    leftView.layer.shadowOpacity = 0.5;
    leftView.layer.shadowRadius = kAutoScaleNormal(8);
    [self addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = [UIColor whiteColor];
    rightView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    rightView.layer.shadowOffset = CGSizeMake(0, 2);
    rightView.layer.shadowOpacity = 0.5;
    rightView.layer.shadowRadius = kAutoScaleNormal(8);
    [self addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    _leftView = leftView;
    _rightView = rightView;
    
    self.layer.cornerRadius = kAutoScaleNormal(8);
    _leftView.layer.cornerRadius = kAutoScaleNormal(8);
    _rightView.layer.cornerRadius = kAutoScaleNormal(8);
    
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    _leftView.backgroundColor = backgroundColor;
    _rightView.backgroundColor = backgroundColor;
}

@end
