//
//  BaseMessageView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BaseMessageView.h"

@interface BaseMessageView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSArray *titlesArray;

@end

@implementation BaseMessageView

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
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self layoutIfNeeded];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    tableView.layer.shadowOffset = CGSizeMake(2, 2);
    tableView.layer.shadowOpacity = 0.8;
    tableView.layer.shadowRadius = 2;
    tableView.clipsToBounds = NO;
    tableView.scrollEnabled = NO;
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [scrollView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@(50 * 6));
    }];
    
    [tableView setSeparatorColor: KHexColor(0xe9e9e9)];
    
    self.titlesArray = @[@"星座",@"身高",@"体重",@"地区",@"职业类别",@"收入"];
    [tableView reloadData];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *baseMessageTableVieWCellIdentifier = @"baseMessageTableVieWCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseMessageTableVieWCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:baseMessageTableVieWCellIdentifier];
    }
    cell.textLabel.text = self.titlesArray[indexPath.row];
    cell.detailTextLabel.text = @"射手座";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(28)];
    return cell;
}

@end
