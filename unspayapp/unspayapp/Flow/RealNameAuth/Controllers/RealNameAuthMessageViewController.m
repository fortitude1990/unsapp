//
//  RealNameAuthMessageViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/30.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RealNameAuthMessageViewController.h"

@interface RealNameAuthMessageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSArray *titlesArray;

@property (nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation RealNameAuthMessageViewController

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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"账户实名认证";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 , kRectWidth, kRectHeight - 64) style:UITableViewStylePlain];
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    
    
    self.titlesArray = @[@"真实姓名",@"证件类型",@"证件号码",@"证件号码",@"证件有效期",@"手机号码"];
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObject:@"123"];
    
    [tableView reloadData];
    
    
}

#pragma mark - BtnActions

- (void)leftBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *realNameAuthMessageViewControllerTablViewCellIdentifier = @"realNameAuthMessageViewControllerTablViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:realNameAuthMessageViewControllerTablViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:realNameAuthMessageViewControllerTablViewCellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.titlesArray[indexPath.row];
    if (indexPath.row < self.dataArray.count) {
        cell.detailTextLabel.text = self.dataArray[indexPath.row];
    }
    
    
    return cell;
}

@end
