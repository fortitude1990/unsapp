//
//  TransferAccountToWalletMessageViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/23.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "TransferAccountToWalletMessageViewController.h"
#import "AuthItem.h"
#import "NextButton.h"
#import "PayTypeView.h"
#import "PasswordView.h"
#import "BankImageHelper.h"
#import "RechargeSuccessViewController.h"
#import "BindCardViewController.h"
#import "Deal.h"
#import "NetworkingUtils.h"
#import "BankCard.h"
#import "BankCardUtils.h"

@interface TransferAccountToWalletMessageViewController ()<UITextViewDelegate, UITextFieldDelegate>;

@property (strong, nonatomic) IBOutlet AuthItem *accountItem;
@property (strong, nonatomic) IBOutlet AuthItem *nameItem;
@property (strong, nonatomic) IBOutlet AuthItem *amountItem;
@property (strong, nonatomic) IBOutlet AuthItem *remarkItem;
@property (strong, nonatomic) IBOutlet UILabel *serverLabel;
@property (strong, nonatomic) IBOutlet NextButton *nextBtn;
@property (strong, nonatomic) IBOutlet UITextView *switchPayTypeTextView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) BankCard *selectBankCard;
@end

@implementation TransferAccountToWalletMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
    [self networking];
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
    
    self.accountItem.titleLabel.text = @"对方账户";
    self.accountItem.textField.text = self.deal.toTel;
    self.accountItem.textField.userInteractionEnabled = NO;
    self.accountItem.hiddenTop = YES;
    
    self.nameItem.titleLabel.text = @"姓名";
    if ([self.deal.toName isEqual:[NSNull null]] || self.deal.toName == nil) {
       self.nameItem.textField.text = nil;
        self.nameItem.textField.userInteractionEnabled = YES;
    }else{
        self.nameItem.textField.text = self.deal.toName;
        self.nameItem.textField.userInteractionEnabled = NO;
    }
    self.nameItem.hiddenBottom = YES;
    self.nameItem.hiddenTop = YES;
    
    self.amountItem.titleLabel.text = @"金额";
    self.amountItem.textField.placeholder = @"请输入转账金额";
    self.amountItem.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.amountItem.hiddenTop = YES;
    self.amountItem.textField.delegate = self;
    
    self.remarkItem.titleLabel.text = @"备注";
    self.remarkItem.textField.placeholder = @"给他捎句话（20字以内，不含特殊符号）";
    self.remarkItem.hiddenTop = YES;
    self.remarkItem.textField.delegate = self;

    [self.nextBtn setTitle:@"确认转账" forState:UIControlStateNormal];
    
    [self.amountItem.textField addTarget:self action:@selector(textfieldValueChange) forControlEvents:UIControlEventEditingChanged];
    [self.remarkItem.textField addTarget:self action:@selector(textfieldValueChange) forControlEvents:UIControlEventEditingChanged];
    

    self.switchPayTypeTextView.linkTextAttributes = @{
                                                      NSForegroundColorAttributeName: KHexColor(0x0068b7),
                                                     
                                                      NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                                    
                                                      NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    self.switchPayTypeTextView.delegate = self;
    self.switchPayTypeTextView.editable = NO;
    self.switchPayTypeTextView.scrollEnabled = NO;
    
    [self settingPayType:@"银行卡（1234）"];

}



#pragma mark - BtnActions

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)nextBtnAction:(id)sender {
    
    PasswordView *passwordView = [[PasswordView alloc] initWithFrame:self.view.bounds];
    [self.navigationController.view addSubview:passwordView];
    
    __weak typeof(self) weakSelf = self;
    [passwordView passwordAuthComplete:^(id data){
        [weakSelf toTransfer:data];
    }];
    
}

- (void)switchBank{
    
    [self.view endEditing:YES];
    
    NSMutableArray *array = [NSMutableArray array];
    
    
    for (BankCard *bankCard in self.listArray) {
        
        NSString *bankNo = [BankCardUtils lastFour:bankCard.bankNo];

        PayTypeModel *model = [[PayTypeModel alloc] init];
        model.title = [NSString stringWithFormat:@"%@(%@)",bankCard.bankName, bankNo ];
        model.imageName = [BankImageHelper gainRealImageName:bankCard.bankName];
        model.params = bankCard;
        
        [array addObject:model];
        
    }


    PayTypeModel *payType = [[PayTypeModel alloc] init];
    payType.imageName = @"添加新卡";
    payType.title = @"使用新银行卡";
    payType.selectImageName = @"右箭头";
    payType.type = PayTypeModelTypeUseNewBank;
    [array addObject:payType];
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    if ([defaultMessage.propertyMsg.availableProperty floatValue] == 0) {
        
        PayTypeModel *payType1 = [[PayTypeModel alloc] init];
        payType1.imageName = @"账户余额灰";
        payType1.title = @"账户余额\n可用余额0.00元";
        payType1.type = PayTypeModelTypeBalanceShow;
        [array addObject:payType1];
        
    }else{
        PayTypeModel *payType2 = [[PayTypeModel alloc] init];
        payType2.imageName = @"账户余额";
        payType2.title = [NSString stringWithFormat:@"账户余额\n可用余额%@元", defaultMessage.propertyMsg.availableProperty] ;
        payType2.type = PayTypeModelTypeUseBalance;
        [array addObject:payType2];
    }
    
    PayTypeView *payTypeView = [[PayTypeView alloc] init];
    payTypeView.elementsArray = array;
    [self.tabBarController.view addSubview:payTypeView];
    [payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(@0);
    }];
    
    [payTypeView show];
    
    [payTypeView callBack:^(PayTypeModel *payTypeModel) {
        
        switch (payTypeModel.type) {
            case PayTypeModelTypeUseBalance:
                [self toSetSelectBankCard:nil];
                break;
            case PayTypeModelTypeDefault:
                [self toSetSelectBankCard:payTypeModel.params];
                break;
            case PayTypeModelTypeUseNewBank:
                [self toBindBankCard];
                break;
            default:
                break;
        }
        
    }];
    
}

#pragma mark - Networking

- (void)transferAccountsNetworking{
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    NSString *payType;
    if (self.selectBankCard == nil) {
        payType = @"0";
    }else{
        payType = @"1";
    }
    
    NSDictionary *params = @{@"accountId" : defaultMessage.accountId,
                             @"transferType" : @"0",
                             @"toAccountId" : self.deal.toAccountId,
                             @"toName" : self.nameItem.textField.text,
                             @"des" : self.remarkItem.textField.text,
                             @"amount" : self.amountItem.textField.text,
                             @"payType" : payType
                             };
    NSMutableDictionary *nextParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    if ([payType isEqualToString:@"1"]) {
        [nextParams setObject:self.selectBankCard.bankNo forKey:@"bankNo"];
        [nextParams setObject:self.selectBankCard.bankName forKey:@"bankName"];
    }
    
    [Networking networkingWithHTTPOfPostTo:kTransferUrl params:nextParams backData:^(NSData *data) {
        
        if (data.length == 0) {
            [PopupAction alertMsg:@"无法连接服务器，请稍后重试" of:self];
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *rspCode = jsonDic[@"rspCode"];
        
        if ([rspCode isEqualToString:@"0000"]) {
            
            defaultMessage.isUpdateBaseMsg = YES;

            RechargeSuccessViewController *successVC = [[RechargeSuccessViewController alloc] init];
            successVC.type = SuccessTypeTransferAccount;
            successVC.amount = self.amountItem.textField.text;
            successVC.bankCard = self.selectBankCard;
            [self.navigationController pushViewController:successVC animated:YES];
            
        }else{
            NSString *rspMsg = jsonDic[@"rspMsg"];
            NSLog(@"%@", rspMsg);
            [PopupAction alertMsg:rspMsg of:self];
        }
        
        
        
        
    }];
    
    
    
}

- (void)verifyPayPwd: (NSString *)pwd networking:(CommonBlock)complete{
    
    [NetworkingUtils verifyPayPwd:pwd networking:^(BOOL flag, NSString *message) {
        complete(flag, message);
    }];
}

- (void)networking{
    
    [ProgressHUB show];
    [NetworkingUtils bankListNetworking:^(BOOL flag, NSString *message, NSArray * returnParams) {
        [ProgressHUB dismiss];
        
        if (flag) {
            
            if ([returnParams isEqual:[NSNull null]] || returnParams == nil || returnParams.count == 0) {
                [[PopupAction defaultPopupAction] popupWithTitle:@"温馨提示" message:@"您还未绑定银行卡，是否进行绑卡" ok:@"再看看" cancel:@"去绑定" okAction:nil cancelAction:^{
                    [self toBindBankCard];
                } of:self];
            }else{
                self.listArray = [NSMutableArray arrayWithArray:returnParams];
            }
            
            if(!self.selectBankCard){
                [self loadData];
            }
            
        }else{
            [PopupAction alertMsg:message of:self];
        }
        
    }];
    
    
}


#pragma mark - Methods


- (void)toTransfer:(NSString *)pwd{
    
    [self verifyPayPwd:pwd networking:^(BOOL flag, NSString *message) {
       
        if (flag) {
            [self transferAccountsNetworking];
        }else{
            [PopupAction alertMsg:message of:self];
        }
        
    }];
    
}

- (void)loadData{
    if (self.listArray.count > 0) {
        BankCard *bankCard = self.listArray.firstObject;
        [self toSetSelectBankCard:bankCard];
    }else{
        [self toSetSelectBankCard:nil];
    }
}


- (void)toSetSelectBankCard: (BankCard *)bankCard{
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    if (bankCard == nil) {
        [self settingPayType:[NSString stringWithFormat:@"账户余额￥%@", defaultMessage.propertyMsg.availableProperty]];
        self.selectBankCard = nil;
    }else{
        NSString *bankNo = [BankCardUtils lastFour:bankCard.bankNo];
        [self settingPayType:[NSString stringWithFormat:@"%@(%@)",bankCard.bankName, bankNo]];
        self.selectBankCard = bankCard;
    }
    
}

- (void)toBindBankCard{
    
    BindCardViewController *bindVC = [[BindCardViewController alloc] init];
    BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:bindVC];
    [self presentViewController:navC animated:YES completion:^{
        
    }];
    
    ReturnBlock callback = ^(BOOL flag, NSString *message, BankCard *bankCard){
        [self networking];
        
        if(bankCard){
            [self toSetSelectBankCard:bankCard];
        }
        
    };
    
    navC.myHandler = callback;
    
    
}


- (void)settingPayType:(NSString *)payType{
    
    NSString *string = [NSString stringWithFormat:@"使用%@，更换",payType];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"switch://"
                             range:[[attributedString string] rangeOfString:@"更换"]];
    self.switchPayTypeTextView.attributedText = attributedString;
    self.switchPayTypeTextView.textAlignment = NSTextAlignmentCenter;

}



- (void)textfieldValueChange{
    
    if (self.amountItem.textField.text.length > 0 && self.remarkItem.textField.text.length > 0) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
    
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    if ([[URL scheme] isEqualToString:@"switch"]) {
        [self switchBank];
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (self.amountItem.textField == textField) {
        [self.remarkItem.textField becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    return YES;
}

@end
