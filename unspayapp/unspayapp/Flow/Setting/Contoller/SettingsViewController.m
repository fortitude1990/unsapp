//
//  SettingsViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/31.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "SettingsViewController.h"
#import "ItemBackView.h"
#import "HeadPortraitViewController.h"
#import "SettingChangeMobileViewController.h"
#import "SettingNicknameViewController.h"
#import "LoginViewController.h"
#import "BankCardUtils.h"

@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    self.navigationItem.title = @"账号管理";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 15;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0); //默认35，设置为负值减少20
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, kRectWidth, 150);
    self.tableView.tableFooterView = footerView;
    
    ItemBackView *backView = [[ItemBackView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(0, 62.5, kRectWidth, 50);
    [footerView addSubview:backView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, kRectWidth, 50);
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:KHexColor(0x000000) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(quitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
}
#pragma mark - Methods

- (void)loadData{
    
}


#pragma mark - BtnActions

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)quitBtnAction{
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navC animated:NO completion:^{
        [self.tabBarController setSelectedIndex:0];
        [(BaseNavController *)self.tabBarController.selectedViewController popToRootViewControllerAnimated:NO];
    }];
    
}

- (void)headPortraitBtnAction{
    
    HeadPortraitViewController *headPortraitVC = [[HeadPortraitViewController alloc] init];
    [self.navigationController pushViewController:headPortraitVC animated:YES];
    [headPortraitVC callBack:^(BOOL flag, NSString *message, UIImage  *returnParams) {
        
        if (flag && returnParams) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.imageView.image = returnParams;
        }

        
    }];
    
}

- (void)changeMobileBtnAction{
    
    SettingChangeMobileViewController *changeVC = [[SettingChangeMobileViewController alloc] init];
    [self.navigationController pushViewController:changeVC animated:YES];
    
}

- (void)nicknameBtnAction{
    
    SettingNicknameViewController *nicknameVC = [[SettingNicknameViewController alloc] init];
    [self.navigationController pushViewController:nicknameVC animated:YES];
    [nicknameVC callBack:^(BOOL flag, NSString *message, id returnParams) {
        if (flag) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            cell1.detailTextLabel.text = returnParams;
            cell.textLabel.text = returnParams;
        }
    }];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 78;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        [self headPortraitBtnAction];
    }
    
    if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0:
                [self nicknameBtnAction];
                break;
            case 1:
                [self changeMobileBtnAction];
                break;
            default:
                break;
        }
        
    }
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *settingsTableViewCellIdentifier = @"settingsTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingsTableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingsTableViewCellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    
    if(indexPath.section == 0){
        cell.imageView.image = [UIImage imageNamed:@"默认头像"];
        cell.textLabel.text = @"用户";

        if(defaultMessage.baseMsg.nickname.length > 0){
            cell.textLabel.text = defaultMessage.baseMsg.nickname;
        }
        
        if (defaultMessage.baseMsg.headPortraitImage.length > 0) {
            UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:defaultMessage.baseMsg.headPortraitImage options:(NSDataBase64DecodingIgnoreUnknownCharacters)]];
            cell.imageView.image = image;
        }
        

//        cell.imageView.layer.cornerRadius = 78.0 / 2.0;
//        cell.imageView.clipsToBounds = YES;
        cell.textLabel.font = [UIFont systemFontOfSize:16];

        
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:15];

        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"昵称";
                cell.detailTextLabel.text = @"";
                if(defaultMessage.baseMsg.nickname.length > 0){
                    cell.detailTextLabel.text = defaultMessage.baseMsg.nickname;
                    
                }
                break;
            case 1:
            {
                cell.textLabel.text = @"更换手机";
                NSString *tel = [[NSUserDefaults standardUserDefaults] objectForKey:kTelKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                cell.detailTextLabel.text = [BankCardUtils recessiveTel:tel];
                break;
            }
            case 2:
                cell.textLabel.text = @"绑定邮箱";
                cell.detailTextLabel.text = @"";
                if(defaultMessage.baseMsg.email.length > 0){
                    cell.detailTextLabel.text = defaultMessage.baseMsg.email;
                }
                break;
            case 3:
                cell.textLabel.text = @"账号安全中心";
                cell.detailTextLabel.text = @"找回密码、申诉";
                break;
            case 4:
                cell.textLabel.text = @"账号操作记录";
                cell.detailTextLabel.text = @"";
                break;
            case 5:
                cell.textLabel.text = @"帮助与反馈";
                cell.detailTextLabel.text = @"";
                break;
            case 6:
                cell.textLabel.text = @"关于银生宝钱包";
                cell.detailTextLabel.text = @"";
                break;
            default:
                break;
        }
        

    }

    
    return cell;
}

@end
