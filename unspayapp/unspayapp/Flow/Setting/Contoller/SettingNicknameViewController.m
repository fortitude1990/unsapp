//
//  SettingNicknameViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/8/10.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "SettingNicknameViewController.h"
#import "NetworkingUtils.h"

@interface SettingNicknameViewController ()<UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *nicknameTF;

@property (nonatomic, copy) ReturnBlock returnBlock;

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
    
    [self.view endEditing:YES];
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    NSDictionary *params = @{@"accountId" : defaultMessage.accountId,
                             @"nickname" : self.nicknameTF.text
                             };
    [ProgressHUB show];
    [NetworkingUtils baseMsg:params upateNetworking:^(BOOL flag, NSString *message) {
        [ProgressHUB dismiss];
        
        if (flag) {
            defaultMessage.isUpdateBaseMsg = YES;
            if (self.returnBlock) {
                self.returnBlock(YES, @"修改成功", self.nicknameTF.text);
            }
            [PopupAction alertMsg:@"修改成功" of:self];
        }else{
            [PopupAction alertMsg:message of:self];
        }
    }];
    
}

- (void)callBack:(ReturnBlock)callback{
    if (callback) {
        self.returnBlock = callback;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

@end
