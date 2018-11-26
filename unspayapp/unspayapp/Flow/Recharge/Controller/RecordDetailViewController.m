//
//  RecordDetailViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "RecordModel.h"
#import "Deal.h"
#import "BankCardUtils.h"
#import "DateFormatUtils.h"

@interface RecordDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSArray *dataArray;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSArray *titleArray;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel * statusLabel;

@property (nonatomic, strong)UILabel * amountLabel;


@end

@implementation RecordDetailViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
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
    
    self.tableView = tableView;
    self.titleLabel = titleLabel;
    self.statusLabel = statusLabel;
    self.amountLabel = amountLabel;
}

#pragma mark - Methods

- (void)loadData{
    
    
    self.amountLabel.text = self.deal.amount;
    
    NSString *payType;
    if ([self.deal.payType isEqualToString:@"0"]) {
        payType = @"账户余额";
    }else{
        payType = [NSString stringWithFormat:@"%@(%@)", self.deal.bankName, [BankCardUtils lastFour:self.deal.bankNo]];
    }
    
    NSString *date = [DateFormatUtils dateString:self.deal.dealTime originalFormat:@"yyyyMMddHHmmss" transferToFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    switch (self.recordType) {
        case RecordTypeRecharge:
        {
            self.navigationItem.title = @"充值详情";
            NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:kTelKey];
            self.titleLabel.text = [@"充值账户 " stringByAppendingString:mobile];
            self.statusLabel.text = @"充值成功";
            
            NSString *transferType;
            transferType = @"充值到钱包账户";
            self.titleArray = @[@"用户名称",
                                @"支付方式",
                                @"交易时间",
                                @"交易单号",
                                @"商户单号",
                                @"交易类型"];
            
            self.dataArray = @[self.deal.name,
                               payType,
                               date,
                               self.deal.orderNo,
                               self.deal.orderNo,
                               transferType
                               ];
            
            break;
        }
        case RecordTypeTransferAccount:{
            
            self.navigationItem.title = @"转账详情";
            self.statusLabel.text = @"转账成功";

            
            NSString *transferType;
            if ([self.deal.transferType isEqualToString:@"0"]) {
                transferType = @"转账到钱包账户";
                self.titleLabel.text = [NSString stringWithFormat:@"转账给%@ %@", self.deal.toName, self.deal.toTel];

            }else{
                transferType = @"转账到银行卡";
                self.titleLabel.text =  [NSString stringWithFormat:@"转账给%@ %@(%@)", self.deal.toName,self.deal.toBankName, [BankCardUtils lastFour:self.deal.toBankNo]];

            }
            
            self.titleArray = @[@"姓名",
                                @"支付方式",
                                @"交易时间",
                                @"交易单号",
                                @"商户单号",
                                @"交易类型"];
            self.dataArray = @[self.deal.name,
                               payType,
                               date,
                               self.deal.orderNo,
                               self.deal.orderNo,
                               transferType
                               ];
            break;
        }
        default:
            break;
    }
    
    [self.tableView reloadData];

    
}

#pragma mark - BtnActions

- (void)leftBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kAutoScaleNormal(100);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
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
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.detailTextLabel.text = self.dataArray[indexPath.row];
    
    return cell;
    
    
    
    
}


@end
