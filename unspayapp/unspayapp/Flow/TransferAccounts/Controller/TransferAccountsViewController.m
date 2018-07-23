//
//  TransferAccountsViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/23.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "TransferAccountsViewController.h"
#import "TransferAccountToWalletViewController.h"

@interface TransferAccountsViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TransferAccountsViewController

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
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"转账";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"转账记录" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBtnAction)];
    self.view.backgroundColor = KHexColor(0xf8f8f8);
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, kRectWidth, kRectHeight - 74) style:UITableViewStylePlain];
    tableView.tableHeaderView = [UIView new];
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    }
    [tableView setSeparatorColor:KHexColor(0xe9e9e9)];

    
}

#pragma mark - BtnActions

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction{
    
}

#pragma mark - Methods


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {  TransferAccountToWalletViewController *walletVC = [[TransferAccountToWalletViewController alloc] init];
            [self.navigationController pushViewController:walletVC animated:YES];
            break;
        }
            
        default:
            break;
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *tranferAccountTableViewCellIdentifier = @"tranferAccountTableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tranferAccountTableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tranferAccountTableViewCellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"转账到银生宝"];
            cell.textLabel.text = @"转账到个人钱包账户";
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"转到银行卡"];
            cell.textLabel.text = @"转账到银行卡";
            break;
        default:
            break;
    }
    

    
    
    
    return cell;
    
}

@end
