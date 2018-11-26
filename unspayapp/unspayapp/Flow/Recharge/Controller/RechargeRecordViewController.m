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
#import "MJRefresh.h"
#import "Deal.h"
#import <NSObject+YYModel.h>
#import "DateFormatUtils.h"

static NSString *rechargeRecordTableViewCellIdentifier = @"RechargeRecordTableViewCellIdentifier";


@interface RechargeRecordViewController ()<UITableViewDelegate, UITableViewDataSource>;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, assign) NSInteger page;


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
    
    if (self.recordType == RecordTypeRecharge) {
        self.navigationItem.title = @"充值记录";
    }
    if (self.recordType == RecordTypeTransferAccount) {
        self.navigationItem.title = @"转账记录";
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kRectWidth,kRectHeight - 64 ) style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:@"RechargeRecordTableViewCell" bundle: nil] forCellReuseIdentifier:rechargeRecordTableViewCellIdentifier];
    
    self.tableView = tableView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        [self networking];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page ++;
        [self networking];
        
    }];

    [self.tableView.mj_header beginRefreshing];
    
    
}

#pragma mark - Methods

- (void)loadData{
    
    
}

- (void)endRefreshing{
    if (self.page == 1) {
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

- (NSArray *)sortByDate:(NSArray *)array{
    
    NSMutableArray *sortArray = [NSMutableArray array];
    NSMutableArray *tempArray;
    NSString *date;
    for (int i = 0; i < array.count; i++) {
        
        Deal *deal = [array objectAtIndex:i];
        
        if (date == nil){
            date = [DateFormatUtils dateString:deal.dealTime originalFormat:@"yyyyMMddHHmmss" transferToFormat:@"yyyyMM"];
            tempArray = [NSMutableArray array];
            [tempArray addObject:deal];
            
            if ([deal isEqual:[array lastObject]]) {
                [sortArray addObject:tempArray];
            }
            
            continue;
        }
        
        if ([date isEqualToString:[DateFormatUtils dateString:deal.dealTime originalFormat:@"yyyyMMddHHmmss" transferToFormat:@"yyyyMM"]]) {
            [tempArray addObject:deal];
        }else{
            [sortArray addObject:tempArray];
            tempArray = [NSMutableArray array];
            date = [DateFormatUtils dateString:deal.dealTime originalFormat:@"yyyyMMddHHmmss" transferToFormat:@"yyyyMM"];
            [tempArray addObject:deal];
            
        }
        
        if ([deal isEqual:[array lastObject]]) {
            [sortArray addObject:tempArray];
        }
        
        
        
        
    }
    
    return sortArray;
}


#pragma mark - BtnActions

- (void)leftBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Networking

- (void)networking{
    
    NSString *queryType = @"1";
    if (self.recordType == RecordTypeRecharge) {
        queryType = @"0";
    }
    if (self.recordType == RecordTypeTransferAccount) {
        queryType = @"2";
    }
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    NSDictionary *params = @{@"accountId" : defaultMessage.accountId,
                             @"page" : [NSString stringWithFormat:@"%ld", (long)self.page],
                             @"pageSize" : @"20",
                             @"queryType" : queryType
                             };
    [Networking networkingWithHTTPOfPostTo:kQueryDealUrl params:params backData:^(NSData *data) {
        
        
        
        if (data.length == 0) {
            [self endRefreshing];
            [PopupAction alertMsg:@"无法连接服务器，请稍后重试" of:self];
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *rspCode = jsonDic[@"rspCode"];
        
        if ([rspCode isEqualToString:@"0000"]) {
            
            NSMutableArray *array = [NSMutableArray array];
            
            NSArray *list = jsonDic[@"list"];
            if(![list isEqual:[NSNull null]] && list != nil){
                for (NSDictionary *dic in list) {
                    Deal *deal = [Deal modelWithJSON:dic];
                    [array addObject:deal];
                }
            }

            if (array.count < 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer resetNoMoreData];
            }
            
            NSMutableArray *sortArray = (NSMutableArray *)[self sortByDate:array];
            
            if (self.page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:sortArray];
            }else{
                
                Deal *deal1 = [[self.dataArray lastObject] firstObject];
                Deal *deal2 = [[sortArray firstObject] firstObject];
                if ([deal1.dealTime isEqualToString:deal2.dealTime]) {
                    
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self.dataArray lastObject]];
                    [tempArray addObjectsFromArray:[sortArray firstObject]];
                    
                    [self.dataArray removeLastObject];
                    [sortArray removeObjectAtIndex:0];
                    
                    [self.dataArray addObject:tempArray];
                    [self.dataArray addObjectsFromArray:sortArray];
                    
                }else{
                    [self.dataArray addObjectsFromArray:sortArray];
                }
            }
            [self endRefreshing];
            
            [self.tableView reloadData];
            
        }else{
            NSString *rspMsg = jsonDic[@"rspMsg"];
            NSLog(@"%@", rspMsg);
        }
        
        
    }];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    Deal *deal = [[self.dataArray objectAtIndex:section] firstObject];
    NSString *date = [DateFormatUtils dateString:deal.dealTime originalFormat:@"yyyyMMddHHmmss" transferToFormat:@"yyyy-MM"];
    NSString *nowDate = [DateFormatUtils nowDate:@"yyyy-MM"];
    if ([date isEqualToString:nowDate]) {
        date = @"本月";
    }
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = KHexColor(0xf8f8f8);
    backView.frame = CGRectMake(0, 0, kRectWidth, 30);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = date;
    [backView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(20, 0, kRectWidth - 20, 30);
    
    return backView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Deal *deal = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    RecordDetailViewController *detailVC = [[RecordDetailViewController alloc] init];
    detailVC.recordType = self.recordType;
    detailVC.deal = deal;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RechargeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rechargeRecordTableViewCellIdentifier forIndexPath:indexPath];
    Deal *deal = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (self.recordType == RecordTypeRecharge) {

        cell.title = @"充值";
        
        cell.date = [DateFormatUtils dateString:deal.dealTime originalFormat:@"yyyyMMddHHmmss" transferToFormat:@"yyyy-MM-dd HH:mm:ss"];
        cell.amount = [@"￥" stringByAppendingString:deal.amount];
        
        cell.status = @"充值成功";
    }
    
    if (self.recordType == RecordTypeTransferAccount) {
        if ([deal.transferType isEqualToString:@"0"]) {
            cell.title = [NSString stringWithFormat:@"转账到：%@", deal.toName];
        }else{
            cell.title = [NSString stringWithFormat:@"转账到卡：%@", deal.toName];
        }
        
        cell.date = [DateFormatUtils dateString:deal.dealTime originalFormat:@"yyyyMMddHHmmss" transferToFormat:@"yyyy-MM-dd HH:mm:ss"];
        cell.amount = [@"￥" stringByAppendingString:deal.amount];
        
        cell.status = @"交易成功";
    }
    

    
    return cell;
}




@end
