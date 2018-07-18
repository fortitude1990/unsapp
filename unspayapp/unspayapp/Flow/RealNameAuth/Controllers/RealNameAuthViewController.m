//
//  RealNameAuthViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RealNameAuthViewController.h"
#import "AuthItem.h"
#import "NextButton.h"
#import "UploadIdCardViewController.h"

@interface RealNameAuthViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet AuthItem *nameItem;
@property (strong, nonatomic) IBOutlet AuthItem *IDTypeItem;
@property (strong, nonatomic) IBOutlet AuthItem *IDItem;
@property (strong, nonatomic) IBOutlet NextButton *nextBtn;


@end

@implementation RealNameAuthViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

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
    
    self.navigationItem.title = @"账户实名认证";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.nameItem.titleLabel.text = @"真实姓名";
    self.nameItem.textField.placeholder = @"请输入真实姓名";
    self.nameItem.textField.delegate = self;
    
    self.IDTypeItem.titleLabel.text = @"证件类型";
    self.IDTypeItem.textField.placeholder = @"请输入证件类型";
    self.IDTypeItem.textField.text = @"身份证";
    self.IDTypeItem.textField.userInteractionEnabled = NO;
    
    self.IDItem.titleLabel.text = @"证件号码";
    self.IDItem.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.IDItem.textField.placeholder = @"请输入证件号码";
    self.IDItem.textField.delegate = self;
    
    [self.nameItem.textField addTarget:self action:@selector(textFieldChangeValue) forControlEvents:UIControlEventEditingChanged];
    [self.IDItem.textField addTarget:self action:@selector(textFieldChangeValue) forControlEvents:UIControlEventEditingChanged];
    
    [self.nextBtn setTitle:@"开始验证" forState:UIControlStateNormal];
    
    
}
#pragma mark - BtnActions

- (void)leftBtnAction{
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}
- (IBAction)nextBtnAction:(id)sender {
    
    UploadIdCardViewController *uploadVC = [[UploadIdCardViewController alloc] init];
    [self.navigationController pushViewController:uploadVC animated:YES];
    
}




#pragma mark - Methods

- (void)textFieldChangeValue{
    
    BOOL flag = self.IDItem.textField.text.length > 0 && self.nameItem.textField.text.length > 0 ? YES : NO;
    if (flag) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.nameItem.textField) {
        [self.IDItem.textField becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    return YES;
}

@end
