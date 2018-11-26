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
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "Deal.h"

@interface TransferAccountToWalletViewController ()<UITextFieldDelegate, CNContactPickerDelegate>

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

    [self.view endEditing:YES];
    [self networking];
    
}

- (IBAction)contactBtnAction:(id)sender {
    
    if (@available(iOS 9.0, *)) {
       
    
        
        CNContactPickerViewController *contactPickerVC = [[CNContactPickerViewController alloc] init];
        contactPickerVC.delegate = self;
        contactPickerVC.displayedPropertyKeys = [NSArray arrayWithObject:CNContactPhoneNumbersKey];

        //不可添加导航器，否则无法正常读取通讯录
//        BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:contactPickerVC];
        [self presentViewController:contactPickerVC animated:YES completion:^{
            
        }];
        
    } else {
        // Fallback on earlier versions
    }
    

    
    
    
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


#pragma mark - Networking

- (void)networking{
    
    NSString *tel = [self.mobileTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *params = @{@"tel" : tel};
    
    [ProgressHUB show];
    [Networking networkingWithHTTPOfPostTo:kVerifyTelUrl params:params backData:^(NSData *data) {
        [ProgressHUB dismiss];
        if (data.length == 0) {
            [PopupAction alertMsg:@"无法连接服务器，请稍后重试" of:self];
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *rspCode = jsonDic[@"rspCode"];
        
        if ([rspCode isEqualToString:@"0000"]) {
            
            Deal *deal = [[Deal alloc] init];
            deal.toName = jsonDic[@"name"];
            deal.toAccountId = jsonDic[@"accountId"];
            deal.toTel = jsonDic[@"tel"];
            deal.dealType = @"2";
            deal.transferType = @"0";
            
            TransferAccountToWalletMessageViewController *messageVC = [[TransferAccountToWalletMessageViewController alloc] init];
            messageVC.deal = deal;
            [self.navigationController pushViewController:messageVC animated:YES];
            
        }else{
            NSString *rspMsg = jsonDic[@"rspMsg"];
            NSLog(@"%@", rspMsg);
            [PopupAction alertMsg:rspMsg of:self];
            
        }
        
        
    }];
    
}

#pragma mark - CNContactPickerDelegate


- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact API_AVAILABLE(ios(9.0)){
    NSLog(@"%@", contact);
    
    CNLabeledValue *labeledValue = contact.phoneNumbers.firstObject;
    CNPhoneNumber *phoneNumber = labeledValue.value;
    
    
    
    //在iOS11 iPhone5s 上面直接使用[string stringByReplacingOccurrencesOfString:@" " withString:@""], 无法去除空格
    NSMutableArray *array = [NSMutableArray array];
    NSUInteger lengthOfString = phoneNumber.stringValue.length;
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
        unichar character = [phoneNumber.stringValue characterAtIndex:loopIndex];
        if (character < 48 || character > 57){
            [array addObject:[[NSString alloc] initWithCharacters:&character length:1]];
        }
    }
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@", phoneNumber.stringValue];
    for(NSString *sub in array){
        string = (NSMutableString *)[string stringByReplacingOccurrencesOfString:sub withString:@""];
    }
    
    self.mobileTF.text = string;
    [self textfieldValueChange];
    
}




#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
@end
