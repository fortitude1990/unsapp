//
//  AmountShowView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/26.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "AmountShowView.h"

@interface AmountShowView()
{
    UILabel *_titleLabel;
    UILabel *_amountLabel;
}
@end

@implementation AmountShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"资产";
    titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(24)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    titleLabel.frame = CGRectMake(0, kAutoScaleNormal(24), self.frame.size.width, kAutoScaleNormal(33));
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.text = @"0.00";
    amountLabel.textColor = KHexColor(0xff821d);
    amountLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(32)];
    [self addSubview:amountLabel];
    amountLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + kAutoScaleNormal(18), CGRectGetWidth(self.frame), kAutoScaleNormal(45));
    
    _amountLabel = amountLabel;
    _titleLabel = titleLabel;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

- (void)setAmount:(NSString *)amount{
    _amount = amount;
    _amountLabel.text = amount;
}


@end
