//
//  PaySettingsView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PaySettingsView.h"

@implementation PaySettingsView

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
        make.top.equalTo(@10);
        make.right.equalTo(@(-15));
        make.height.equalTo(backView.mas_width).multipliedBy(0.8);
    }];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = @"扣款顺序";
    cell.textLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    cell.detailTextLabel.text = @"系统默认";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(28)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [backView addSubview:cell];
    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@(kAutoScaleNormal(99)));
    }];
    
    UIView *oneLine = [[UIView alloc] init];
    oneLine.backgroundColor = KHexColor(0xe9e9e9);
    [backView addSubview:oneLine];
    [oneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(cell.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    UITableViewCell *cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell1.textLabel.text = @"小额免密支付";
    cell1.textLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    cell1.detailTextLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(28)];
    [backView addSubview:cell1];
    [cell1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneLine.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@(kAutoScaleNormal(99)));
    }];
    
    UISwitch *switchBtn = [[UISwitch alloc] init];
    [cell1 addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.width.equalTo(@50);
        make.height.equalTo(@30);
        make.centerY.equalTo(cell1);
    }];
    
    UIView *twoLine = [[UIView alloc] init];
    twoLine.backgroundColor = oneLine.backgroundColor;
    [backView addSubview:twoLine];
    [twoLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.top.equalTo(cell1.mas_bottom);
    }];
    
    UILabel *remindLabel = [[UILabel alloc] init];
    remindLabel.text = @"手机付款金额小于等于200元/笔，无需输入支付密码";
    remindLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(26)];
    remindLabel.textColor = KHexColor(0x6d6d72);
    [backView addSubview:remindLabel];
    [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@(-10));
        make.height.equalTo(@22);
        make.top.equalTo(twoLine.mas_bottom).offset(10);
    }];
    
}

@end
