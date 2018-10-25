//
//  MeansView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/13.
//  Copyright © 2018年 李志敬. All rights reserved.
//


#import "MeansView.h"
#import "HistogramView.h"

#define kMargin 15

@interface MeansView()
{
    HistogramView *_totalMeans;
    HistogramView *_balance;
    HistogramView *_incomeYD;
    HistogramView *_expendYD;
    CommonBlock _block;
}

@end


@implementation MeansView

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

- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.8;
    
    self.layer.cornerRadius = kAutoScaleNormal(8);
//    self.clipsToBounds = YES;
    
    UILabel *meansTitleLabel = [[UILabel alloc] init];
    meansTitleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    meansTitleLabel.text = @"我的资产";
    [self addSubview:meansTitleLabel];
    [meansTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kMargin));
        make.top.equalTo(@(10));
        make.height.equalTo(@24);
        make.width.equalTo(@100);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-kMargin));
        make.width.equalTo(@10);
        make.height.equalTo(@10);
        make.centerY.equalTo(meansTitleLabel);
    }];
   
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = KHexColor(0xe9e9e9);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kMargin));
        make.right.equalTo(@(-kMargin));
        make.top.equalTo(meansTitleLabel.mas_bottom).offset(10);
        make.height.equalTo(@0.5);
    }];
    
    UILabel *unitLabel = [[UILabel alloc] init];
    unitLabel.text = @"单位：元";
    unitLabel.textAlignment = NSTextAlignmentRight;
    unitLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(20)];
    [self addSubview:unitLabel];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(@(kMargin));
        make.right.equalTo(@(-kMargin));
        make.height.equalTo(@(kAutoScaleNormal(50)));
    }];
    
    UIView *histogramBackView = [[UIView alloc] init];
    [self addSubview:histogramBackView];
    [histogramBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(unitLabel.mas_bottom);
        make.bottom.equalTo(@(-kMargin));
    }];
    
    HistogramView *totalMeans = [[HistogramView alloc] init];
    totalMeans.percentageColor = KHexColor(0x0087ee);
    totalMeans.title = @"总资产";
    [histogramBackView addSubview:totalMeans];
    [totalMeans mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(@0);
        make.width.equalTo(histogramBackView.mas_width).multipliedBy(0.25);
    }];
    
    HistogramView *balance = [[HistogramView alloc] init];
    balance.percentageColor = KHexColor(0xfb696a);
    balance.title = @"钱包余额";
    [histogramBackView addSubview:balance];
    [balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalMeans.mas_right);
        make.top.bottom.equalTo(@0);
        make.width.equalTo(histogramBackView.mas_width).multipliedBy(0.25);
    }];
    
    HistogramView *incomeYD = [[HistogramView alloc] init];
    incomeYD.percentageColor = KHexColor(0xffaa00);
    incomeYD.title = @"昨日收入";
    [histogramBackView addSubview:incomeYD];
    [incomeYD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(balance.mas_right);
        make.top.bottom.equalTo(@0);
        make.width.equalTo(histogramBackView.mas_width).multipliedBy(0.25);
    }];
    
    HistogramView *expendYD = [[HistogramView alloc] init];
    expendYD.percentageColor = KHexColor(0xffb47b);
    expendYD.title = @"昨日支出";
    [histogramBackView addSubview:expendYD];
    [expendYD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(incomeYD.mas_right);
        make.top.bottom.equalTo(@0);
        make.width.equalTo(histogramBackView.mas_width).multipliedBy(0.25);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction)];
    [self addGestureRecognizer:tap];
    
    
    _totalMeans = totalMeans;
    _balance = balance;
    _incomeYD = incomeYD;
    _expendYD = expendYD;


}

- (void)tapGesAction{
    if (_block) {
        _block(YES, nil);
    }
}

- (void)tapAction:(CommonBlock)action{
    if (action) {
        _block = action;
    }
}

- (void)updateData{
    
    DefaultMessage *defaultMessage = DefaultMessage.shareMessage;
    _totalMeans.amount = defaultMessage.propertyMsg.totalProperty;
    _balance.amount = defaultMessage.propertyMsg.availableProperty;
    _incomeYD.amount = defaultMessage.propertyMsg.yesterdayIncome;
    _expendYD.amount = defaultMessage.propertyMsg.yesterdaySpending;
    
    
    _totalMeans.percentage = 1.0;
    _balance.percentage = _balance.amount.floatValue / _totalMeans.amount.floatValue;
    _incomeYD.percentage = _incomeYD.amount.floatValue / _totalMeans.amount.floatValue;
    _expendYD.percentage = _expendYD.amount.floatValue / _totalMeans.amount.floatValue;
    
}

@end
