//
//  RechargeNoneBindCardViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/18.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RechargeNoneBindCardViewController.h"
#import "BindCardViewController.h"

@interface RechargeNoneBindCardViewController ()

@property (strong, nonatomic) IBOutlet UIButton *nextBtn;


@end

@implementation RechargeNoneBindCardViewController

#pragma mark - LifeCycle

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
    
    self.nextBtn.layer.cornerRadius = 3;
    self.nextBtn.clipsToBounds = YES;
    
    self.navigationItem.title = @"账户充值";
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    
}

#pragma mark - BtnActions

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextBtnAction:(id)sender {
    
    BindCardViewController *bindCardVC = [[BindCardViewController alloc] init];
    BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:bindCardVC];
    [self presentViewController:navC animated:YES completion:^{
        [self leftBtnAction];
    }];
    
}


#pragma mark - Methods



@end
