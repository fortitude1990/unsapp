//
//  SettingNicknameViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/8/10.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "SettingNicknameViewController.h"

@interface SettingNicknameViewController ()<UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *nicknameTF;

@end

@implementation SettingNicknameViewController

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
    
    self.navigationItem.title = @"昵称设置";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveNicknameBtnAction)];
    
    self.nicknameTF.delegate = self;
}

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveNicknameBtnAction{
    
    
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

@end
