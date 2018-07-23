//
//  PwdSettingSuccessViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/23.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PwdSettingSuccessViewController.h"

@interface PwdSettingSuccessViewController ()

@end

@implementation PwdSettingSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"设置支付密码";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
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
    
}

@end
