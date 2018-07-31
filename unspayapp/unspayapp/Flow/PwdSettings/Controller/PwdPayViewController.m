//
//  PwdPayViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/30.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PwdPayViewController.h"
#import "Pay_Password_ViewController.h"

@interface PwdPayViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray *titlesArray;

@end

@implementation PwdPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    self.tableView.tableFooterView = [UIView new];
    
    switch (self.listType) {
        case ListTypeChangePwd:
            self.navigationItem.title = @"支付密码";
            self.titlesArray = @[@"修改支付密码",@"忘记支付密码"];
            break;
        case ListTypeForgetPwd:
            self.navigationItem.title = @"找回支付密码";
            self.titlesArray = @[@"用绑定手机找回支付密码",@"用绑定邮箱找回支付密码"];
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
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

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.listType == ListTypeChangePwd) {
        switch (indexPath.row) {
            case 0:
            {
                Pay_Password_ViewController *realVC = [[Pay_Password_ViewController alloc] init];
                realVC.passwordInputType = PasswordInputTypeDefault;
                BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:realVC];
                [self presentViewController:navC animated:YES completion:^{
                    
                }];
                __weak typeof(self) weakSelf = self;
                [realVC sendValue:^(BOOL flag, NSString *message) {
                    
                    if (flag) {
                        
                        Pay_Password_ViewController *changeVC = [[Pay_Password_ViewController alloc] init];
                        changeVC.passwordInputType = PasswordInputTypeSimpleChange;
                        BaseNavController *naVC = [[BaseNavController alloc] initWithRootViewController:changeVC];
                        [weakSelf presentViewController:naVC animated:YES completion:^{
                            
                        }];
                        
                    }else{
                        [PopupAction showMessage:message location:ShowLocationMid];
                    }
                }];
                
                break;
            }
            case 1:
            {   PwdPayViewController *forgetVC = [[PwdPayViewController alloc] init];
                forgetVC.listType = ListTypeForgetPwd;
                [self.navigationController pushViewController:forgetVC animated:YES];
                break;
            }
            default:
                break;
        }
        
    }else{
        
        switch (indexPath.row) {
            case 0:
                break;
                
            default:
                break;
        }
        
    }
    
    
    
}


#pragma mark - UITableViewDataSource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlesArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *pwdPayViewControllerTableViewCellIdentifier = @"pwdPayViewControllerTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pwdPayViewControllerTableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pwdPayViewControllerTableViewCellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.textLabel.text = self.titlesArray[indexPath.row];
    
    return cell;
}

@end
