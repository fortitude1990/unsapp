//
//  PwdPayFindIDViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/31.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PwdPayFindIDViewController.h"
#import "NextButton.h"
#import "Pay_Password_ViewController.h"

@interface PwdPayFindIDViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *IDTF;

@property (strong, nonatomic) IBOutlet NextButton *nextBtn;

@end

@implementation PwdPayFindIDViewController

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
    
    self.navigationItem.title = @"找回支付密码";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.IDTF.delegate = self;
    [self.IDTF addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Methods
- (void)textFieldValueChange{
    
    if (self.IDTF.text.length > 0) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
    
}

#pragma mark - BtnActions
- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextBtnAction:(id)sender {
    
    Pay_Password_ViewController *changeVC = [[Pay_Password_ViewController alloc] init];
    changeVC.passwordInputType = PasswordInputTypeSimpleChange;
    BaseNavController *naVC = [[BaseNavController alloc] initWithRootViewController:changeVC];
    [self presentViewController:naVC animated:YES completion:^{
        
    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    return YES;
}
@end
