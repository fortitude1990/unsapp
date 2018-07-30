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



@end

@implementation PwdPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"支付密码";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    self.tableView.tableFooterView = [UIView new];
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
            
            break;
        default:
            break;
    }
}


#pragma mark - UITableViewDataSource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *pwdPayViewControllerTableViewCellIdentifier = @"pwdPayViewControllerTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pwdPayViewControllerTableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pwdPayViewControllerTableViewCellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"修改支付密码";
            break;
        case 1:
            cell.textLabel.text = @"忘记支付密码";
            break;
            
        default:
            break;
    }
    
    return cell;
}

@end
