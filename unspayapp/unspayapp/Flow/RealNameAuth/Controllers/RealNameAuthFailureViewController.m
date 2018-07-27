//
//  RealNameAuthFailureViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/27.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RealNameAuthFailureViewController.h"
#import "RealNameAuthViewController.h"
#import "NextButton.h"

@interface RealNameAuthFailureViewController ()
@property (strong, nonatomic) IBOutlet UITextView *reasonTextView;
@property (strong, nonatomic) IBOutlet NextButton *nextBtn;

@end

@implementation RealNameAuthFailureViewController

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
    self.navigationItem.title = @"实名认证";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    [self.nextBtn setTitle:@"重新上传身份证" forState:UIControlStateNormal];
    [self.nextBtn canResponse];
    
    self.reasonTextView.scrollEnabled = NO;
    self.reasonTextView.userInteractionEnabled = NO;
    

}

- (IBAction)nextBtnAction:(id)sender {
    
    RealNameAuthViewController *realVC = [[RealNameAuthViewController alloc] init];
    BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:realVC];
    [self presentViewController:navC animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
