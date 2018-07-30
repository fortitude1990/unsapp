//
//  PwdLoginSecondViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/30.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PwdLoginSecondViewController.h"
#import "AuthItem.h"
#import "NextButton.h"

@interface PwdLoginSecondViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet AuthItem *oneItem;

@property (strong, nonatomic) IBOutlet AuthItem *twoItem;
@property (strong, nonatomic) IBOutlet NextButton *nextBtn;

@end

@implementation PwdLoginSecondViewController

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
    
    self.navigationItem.title = @"登录密码";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.oneItem.titleLabel.text = @"输入密码";
    self.oneItem.textField.placeholder = @"请输入密码";
    self.oneItem.textField.secureTextEntry = YES;
    
    self.twoItem.titleLabel.text = @"再次输入密码";
    self.twoItem.textField.placeholder = @"请再次输入密码";
    self.twoItem.textField.secureTextEntry = YES;
    
    self.oneItem.textField.delegate = self;
    self.twoItem.textField.delegate = self;
    
    [self.oneItem.textField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventEditingChanged];
    [self.twoItem.textField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventEditingChanged];

    
}

#pragma mark - BtnActions

- (void)leftBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)nextBtnAction:(id)sender {
    
    if (![self.oneItem.textField.text isEqualToString:self.twoItem.textField.text]) {
        [PopupAction showMessage:@"再次输入密码错误" location:(ShowLocationMid)];
        self.oneItem.textField.text = nil;
        self.twoItem.textField.text = nil;
        return;
    }
    
}

#pragma mark - Methods

- (void)textFieldValueChange{
    
    if (self.oneItem.textField.text.length > 0 && self.twoItem.textField.text.length > 0) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.oneItem.textField) {
        [self.twoItem.textField becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    return YES;
}

@end
