//
//  TransferAccountToWalletViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/23.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "TransferAccountToWalletViewController.h"
#import "NextButton.h"
#import "TransferAccountToWalletMessageViewController.h"


@interface TransferAccountToWalletViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *mobileTF;

@property (strong, nonatomic) IBOutlet UIButton *contactBtn;

@property (strong, nonatomic) IBOutlet NextButton *nextBtn;

@end

@implementation TransferAccountToWalletViewController

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
    
    self.navigationItem.title = @"转账到个人钱包账户";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    self.mobileTF.delegate = self;
    [self.mobileTF addTarget:self action:@selector(textfieldValueChange) forControlEvents:UIControlEventEditingChanged];
    
}


#pragma mark - BtnActions

- (IBAction)nextBtnAction:(id)sender {
    
    TransferAccountToWalletMessageViewController *messageVC = [[TransferAccountToWalletMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
    
}

- (IBAction)contactBtnAction:(id)sender {
    
}

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Methods

- (void)textfieldValueChange{
    
    if (self.mobileTF.text.length > 0) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
@end
