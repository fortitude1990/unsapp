//
//  RealNameAuthStatusViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RealNameAuthStatusViewController.h"

@interface RealNameAuthStatusViewController ()

@property (strong, nonatomic) IBOutlet UILabel *submitDateLabel;
@end

@implementation RealNameAuthStatusViewController



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
    
    self.navigationItem.title = @"实名认证";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    
}

#pragma mark - BtnActions

- (void)leftBtnAction{
    
    switch (self.quitType) {
        case QuitTypePop:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case QuitTypeDismiss:
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            break;
        default:
            break;
    }
    
}

@end
