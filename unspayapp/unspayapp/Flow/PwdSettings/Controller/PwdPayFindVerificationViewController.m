//
//  PwdPayFindVerificationViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/30.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PwdPayFindVerificationViewController.h"
#import "TimerButton.h"
#import "NextButton.h"
@interface PwdPayFindVerificationViewController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *verificationTF;
@property (strong, nonatomic) IBOutlet TimerButton *verificationBtn;

@property (strong, nonatomic) IBOutlet NextButton *nextBtn;
@end

@implementation PwdPayFindVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
- (IBAction)verificationBtnAction:(id)sender {
    
}
- (IBAction)nextBtnAction:(id)sender {
}

@end
