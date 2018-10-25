//
//  RegisterSuccessViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/11.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RegisterSuccessViewController.h"

@interface RegisterSuccessViewController ()

@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation RegisterSuccessViewController

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
    
    
    
    self.navigationItem.title = @"注册";
    
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.nextBtn.layer.cornerRadius = 22;
    self.nextBtn.clipsToBounds = YES;
    
}

- (void)leftBtnAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)nextBtnAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

@end
