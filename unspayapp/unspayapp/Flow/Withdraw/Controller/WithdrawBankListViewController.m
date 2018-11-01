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
#import "BankCard.h"
#import "BankCardUtils.h"
#import "BankImageHelper.h"

static NSString * bankListTableViewCellIdentifier = @"bankListTableViewCellIdentifier";

@interface WithdrawBankListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, copy) ReturnBlock reurnBlock;

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

- (BankListModel *)transferToBankListModel:(BankCard *)bankCard{
    
    BankListModel *model1 = [[BankListModel alloc] init];
    model1.bankName = bankCard.bankName;
    if ([bankCard.cardType isEqualToString:@"0"]) {
        model1.bankType = @"储蓄卡";
    }else{
        model1.bankType = @"信用卡";
    }
    model1.bankCardNo = [BankCardUtils reservedLastFourAndNeat:bankCard.bankNo];
    model1.bankImageName = [BankImageHelper gainRealImageName:bankCard.bankName];
    
    if ([self.selectBankCard isEqual:bankCard]) {
        model1.isSelected = YES;
    }else{
        model1.isSelected = NO;
    }
    model1.params = bankCard;
    
    return model1;
}

- (void)loadData{
    
    self.dataArray = [NSMutableArray array];
    
    
    for (BankCard *bankCard in self.listArray){
        BankListModel *model = [self transferToBankListModel:bankCard];
        [self.dataArray addObject:model];
    }

    
    [self.tableView reloadData];
}

- (void)callback:(ReturnBlock)callback{
    if (callback) {
        self.reurnBlock = callback;
    }
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
    
    typeof(self) weakSelf = self;
    ReturnBlock callback = ^(BOOL flag, NSString *message, BankCard *bankCard){
       
        if (flag && bankCard) {
            BankListModel *model = [self transferToBankListModel:bankCard];
            [weakSelf.dataArray addObject:model];
            [weakSelf.tableView reloadData];
            if (weakSelf.reurnBlock) {
                weakSelf.reurnBlock(YES, @"选择成功", nil);
            }
        }
        
    };
    
    navC.myHandler = callback;
    
    
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
    
    if (self.reurnBlock) {
        self.reurnBlock(NO, @"选择成功", model.params);
    }
    
    
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
