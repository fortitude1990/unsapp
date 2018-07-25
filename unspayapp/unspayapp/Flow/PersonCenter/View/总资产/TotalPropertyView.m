//
//  TotalPropertyView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "TotalPropertyView.h"

@implementation TotalPropertyView

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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRectWidth, kAutoScaleNormal(410))];
    tableView.tableHeaderView = headerView;

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    backView.layer.shadowOffset = CGSizeMake(2, 2);
    backView.layer.shadowOpacity = 0.8;
    backView.layer.shadowRadius = 2;
    [headerView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@(kAutoScaleNormal(30)));
        make.right.equalTo(@(-15));
        make.height.equalTo(@(kAutoScaleNormal(380)));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"总资产";
    
    
    
    
    
}

@end
