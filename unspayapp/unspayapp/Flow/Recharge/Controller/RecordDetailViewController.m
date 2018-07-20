//
//  RecordDetailViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RecordDetailViewController.h"

@interface RecordDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation RecordDetailViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CreateUI

- (void)createUI{
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = KHexColor(0xf8f8f8);
    headerView.frame = CGRectMake(0, 0, kRectWidth, kAutoScaleNormal(300));
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"充值账户 176********";
    [headerView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(0,  kAutoScaleNormal(31), kRectWidth, kAutoScaleNormal(45));
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.text = @"充值成功";
    statusLabel.textColor = KHexColor(0x6d6d72);
    [headerView addSubview:statusLabel];
    statusLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + kAutoScaleNormal(52), kRectWidth, kAutoScaleNormal(42));
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(70)];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.text = @"0.00";
    amountLabel.textColor = KHexColor(0x0068b7);
    [headerView addSubview:amountLabel];
    amountLabel.frame = CGRectMake(0, CGRectGetMaxY(statusLabel.frame) + kAutoScaleNormal(16), kRectWidth, kAutoScaleNormal(78));
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kRectWidth, kRectHeight - 64) style:UITableViewStylePlain];
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    
}

#pragma mark - Methods

- (void)loadData{
    
}

#pragma mark - BtnActions

- (void)leftBtnAction{
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kAutoScaleNormal(100);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *recordDetailIdentifier = @"recordDetailIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordDetailIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recordDetailIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    cell.textLabel.textColor = KHexColor(0x6d6d72);
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    cell.textLabel.text = @"用户名称";
    cell.detailTextLabel.text = @"张三疯";
    
    return cell;
    
    
    
    
}


@end
