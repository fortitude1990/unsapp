//
//  ChangeMobileOrEmailGainVerificaitonViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/8/13.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "ChangeMobileOrEmailGainVerificaitonViewController.h"
#import "TimerButton.h"
#import "NextButton.h"


@interface ChangeMobileOrEmailGainVerificaitonViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *verificationTf;
@property (strong, nonatomic) IBOutlet TimerButton *verificationBtn;
@property (strong, nonatomic) IBOutlet NextButton *nextBtn;

@end

@implementation ChangeMobileOrEmailGainVerificaitonViewController

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
    
    self.navigationItem.title = @"换绑手机";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.verificationTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.verificationTf.delegate = self;
    
    [self.nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [self.verificationTf addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventEditingChanged];
    
}

#pragma mark - Methods

- (void)textFieldValueChange{
    
    if (self.verificationTf.text.length > 0) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
    
}

#pragma mark - BtnActions

- (IBAction)verificationBtnAction:(id)sender {
    
    [self.verificationBtn startTimerTotalTime:60 doningTintColor:KHexColor(0x6d6d72) doingBackgroundColor:nil unit:@"s"];
    
}

- (IBAction)nextBtnAction:(id)sender {
    
}

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
}

@end
