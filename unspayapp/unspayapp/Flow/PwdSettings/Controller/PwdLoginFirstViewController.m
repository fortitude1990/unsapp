//
//  PwdLoginFirstViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/30.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PwdLoginFirstViewController.h"
#import "PwdLoginSecondViewController.h"
#import "GestureViewController.h"

@interface PwdLoginFirstViewController ()


@property (strong, nonatomic) IBOutlet UIView *nextView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

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
            self.titleLabel.text = @"设置登陆密码";
            break;
        case PwdSettingTypeLoginChange:
            self.navigationItem.title = @"登录密码";
            self.titleLabel.text = @"修改登陆密码";
            break;
        case PwdSettingTypeGesture:
            self.navigationItem.title = @"手势密码";
            self.titleLabel.text = @"设置手势密码";
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
    
    switch (self.pwdSettingType) {
        case PwdSettingTypeLogin:
        {
            PwdLoginSecondViewController *secondVC = [[PwdLoginSecondViewController alloc] init];
            [self.navigationController pushViewController:secondVC animated:YES];
            break;
        }
        case PwdSettingTypeLoginChange:
        {
            PwdLoginSecondViewController *secondVC = [[PwdLoginSecondViewController alloc] init];
            [self.navigationController pushViewController:secondVC animated:YES];
            break;
        }
        case PwdSettingTypeGesture:
        {
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            gestureVc.type = GestureViewControllerTypeSetting;
            [self.navigationController pushViewController:gestureVc animated:YES];
            break;
        }

        default:
            break;
    }
    

    

    
}

@end
