//
//  WithdrawResultViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "WithdrawResultViewController.h"

@interface WithdrawResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *applicationTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation WithdrawResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.navigationController.navigationBar.hidden = YES;
    self.nextBtn.layer.cornerRadius = kAutoScaleNormal(6);
    self.nextBtn.clipsToBounds = YES;
    
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
- (IBAction)nextBtnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
