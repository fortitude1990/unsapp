//
//  PwdLoginFirstViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/30.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PwdLoginFirstViewController.h"
#import "PwdLoginSecondViewController.h"

@interface PwdLoginFirstViewController ()

@property (strong, nonatomic) IBOutlet UIView *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *nextView;

@end

@implementation PwdLoginFirstViewController

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

- (void)createUI{
    
    switch (self.pwdSettingType) {
        case PwdSettingTypeLogin:
            self.navigationItem.title = @"登录密码";
            break;
        case PwdSettingTypeLoginChange:
            self.navigationItem.title = @"登录密码";
            break;
        default:
            break;
    }
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction)];
    [self.nextView addGestureRecognizer:tapGes];

    
}

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapGesAction{
    
    PwdLoginSecondViewController *secondVC = [[PwdLoginSecondViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
    
}

@end
