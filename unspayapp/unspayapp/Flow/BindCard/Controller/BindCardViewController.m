//
//  BindCardViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BindCardViewController.h"
#import "AuthItem.h"
#import "NextButton.h"
#import "BindCardVerificationViewController.h"

@interface BindCardViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet AuthItem *oneItem;
@property (strong, nonatomic) IBOutlet AuthItem *twoItem;
@property (strong, nonatomic) IBOutlet NextButton *nextBtn;

@end

@implementation BindCardViewController

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
   
    self.navigationItem.title = @"添加银行卡";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.oneItem.titleLabel.text = @"持卡人";
    self.oneItem.textField.textAlignment = NSTextAlignmentLeft;
    self.oneItem.textField.text = @"张三";

    self.twoItem.titleLabel.text = @"银行卡号";
    self.twoItem.textField.textAlignment = NSTextAlignmentLeft;
    self.twoItem.textField.placeholder = @"请输入本人的银行卡号";
    self.twoItem.textField.delegate = self;
    self.twoItem.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [self.twoItem.textField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventEditingChanged];
    
    [self.nextBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    
}

#pragma mark - BtnActions

- (IBAction)nextBtnAction:(id)sender {
    
    BindCardVerificationViewController *verificationVC = [[BindCardVerificationViewController alloc] init];
    [self.navigationController pushViewController:verificationVC animated:YES];
    
}

- (void)leftBtnAction{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark - Methods

- (void)textFieldValueChange{
    if (self.twoItem.textField.text.length > 0) {
        [self.nextBtn canResponse];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

@end
