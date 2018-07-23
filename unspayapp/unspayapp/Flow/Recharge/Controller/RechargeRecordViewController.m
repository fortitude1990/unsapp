//
//  RechargeRecordViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RechargeRecordViewController.h"
#import "RechargeRecordTableViewCell.h"
#import "RecordModel.h"
#import "RecordDetailViewController.h"

static NSString *rechargeRecordTableViewCellIdentifier = @"RechargeRecordTableViewCellIdentifier";


@interface RechargeRecordViewController ()<UITableViewDelegate, UITableViewDataSource>;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation RechargeRecordViewController

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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"充值记录";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kRectWidth,kRectHeight - 64 ) style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:@"RechargeRecordTableViewCell" bundle: nil] forCellReuseIdentifier:rechargeRecordTableViewCellIdentifier];
    
    self.tableView = tableView;
}

#pragma mark - Methods

- (void)loadData{
    
    
}

#pragma mark - BtnActions

- (void)leftBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 30;
//}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = KHexColor(0xf8f8f8);
    backView.frame = CGRectMake(0, 0, kRectWidth, 30);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"本月";
    [backView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(20, 0, kRectWidth - 20, 30);
    
    return backView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecordDetailViewController *detailVC = [[RecordDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RechargeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rechargeRecordTableViewCellIdentifier forIndexPath:indexPath];
    return cell;
}




@end
