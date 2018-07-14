//
//  HistogramView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/13.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "HistogramView.h"

@interface HistogramView()
{
    UILabel *_amountLabel;
    UILabel *_titleLabel;
}

@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIView *measureView;

@end

@implementation HistogramView

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
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = @"0.00";
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.textColor = KHexColor(0xff821d);
    amountLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(28)];
    [self addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@(kAutoScaleNormal(40)));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"总资产";
    titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(26)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@(kAutoScaleNormal(40)));
    }];
    
    
    UIView *backView = [[UIView alloc] init];
    backView.layer.cornerRadius = kAutoScaleNormal(4);
    backView.clipsToBounds = YES;
    backView.backgroundColor = KHexColor(0xEDEFF7);
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLabel.mas_bottom).offset(kAutoScaleNormal(18));
        make.width.equalTo(@(kAutoScaleNormal(80)));
        make.bottom.equalTo(titleLabel.mas_top).offset(-kAutoScaleNormal(18));
        make.centerX.equalTo(self);
    }];
    
    UIView *measureView = [[UIView alloc] init];
    measureView.backgroundColor = KHexColor(0x0087ee);
    [backView addSubview:measureView];
    [measureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(backView.mas_height).multipliedBy(0.5);
    }];
    
    _amountLabel = amountLabel;
    _titleLabel = titleLabel;
    _measureView = measureView;
    _backView = backView;
}

- (void)setAmount:(NSString *)amount{
    _amountLabel.text = amount;
    _amount = amount;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

- (void)setPercentage:(CGFloat)percentage{
    
    if (percentage > 1) {
        _percentage = 1.0;
    }else{
        _percentage = percentage;
    }
    
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:1 animations:^{
            
            [weakSelf.measureView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(@0);
                make.height.equalTo(weakSelf.backView.mas_height).multipliedBy(percentage);
            }];
            
            [weakSelf.measureView.superview layoutIfNeeded];
            
        }];
        
    });
    

    

    
}

- (void)setPercentageColor:(UIColor *)percentageColor{
    _percentageColor = percentageColor;
    _measureView.backgroundColor = percentageColor;
}

@end
