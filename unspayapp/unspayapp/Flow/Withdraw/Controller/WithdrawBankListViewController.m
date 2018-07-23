//
//  WithdrawBankListViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "WithdrawBankListViewController.h"
#import "BankListTableViewCell.h"
#import "BindCardViewController.h"

static NSString * bankListTableViewCellIdentifier = @"bankListTableViewCellIdentifier";

@interface WithdrawBankListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)UITableView *tableView;


@end

@implementation WithdrawBankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    
    self.navigationItem.title = @"选择银行卡";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(rightBtnAction)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 10, kRectWidth, kRectHeight - 64 - 10) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = [UIView new];
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:@"BankListTableViewCell" bundle:nil] forCellReuseIdentifier:bankListTableViewCellIdentifier];
    
    self.tableView = tableView;
    
   
    
}

#pragma mark - Methods
- (void)loadData{
    
    self.dataArray = [NSMutableArray array];
    
    BankListModel *model1 = [[BankListModel alloc] init];
    model1.bankName = @"中国工商银行";
    model1.bankType = @"储蓄卡";
    model1.bankCardNo = @"1234 1234 1234 1234";
    model1.bankImageName = @"中国工商银行";
    model1.isSelected = NO;
    
    BankListModel *model2 = [[BankListModel alloc] init];
    model2.bankName = @"中国银行";
    model2.bankType = @"储蓄卡";
    model2.bankCardNo = @"1234 1234 1234 1234";
    model2.bankImageName = @"中国银行";
    model2.isSelected = NO;
    
    [self.dataArray addObject:model1];
    [self.dataArray addObject:model2];
    
    [self.tableView reloadData];
}

#pragma mark - BtnActions
- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction{
    
    BindCardViewController *bindVC = [[BindCardViewController alloc] init];
    BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:bindVC];
    [self presentViewController:navC animated:YES completion:^{
        
    }];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    [self.dataArray enumerateObjectsUsingBlock:^(BankListModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(obj.isSelected == YES){
            obj.isSelected = NO;
            [self.dataArray replaceObjectAtIndex:idx withObject:obj];
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:idx inSection:indexPath.section];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }];

    BankListModel *model = self.dataArray[indexPath.row];
    model.isSelected = YES;
    [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    BankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bankListTableViewCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bankListModel = self.dataArray[indexPath.row];
    return cell;
    
}


@end
