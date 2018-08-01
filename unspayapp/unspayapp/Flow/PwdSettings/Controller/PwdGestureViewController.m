//
//  PwdGestureViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/31.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PwdGestureViewController.h"
#import "GestureVerifyViewController.h"

@interface PwdGestureViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *switchBtn;
@property (strong, nonatomic) IBOutlet UIView *twoItemView;

@end

@implementation PwdGestureViewController

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
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"手势密码";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction)];
    [self.twoItemView addGestureRecognizer:tap];
    
}
- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)switchBtnAction:(id)sender {
    
    
}

- (void)tapGesAction{
    
    GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
    gestureVerifyVc.isToSetNewGesture = YES;
    [self.navigationController pushViewController:gestureVerifyVc animated:YES];
    
}
@end
