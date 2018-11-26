//
//  TransferAccountToBankViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "TransferAccountToBankViewController.h"
#import "AuthItem.h"
#import "NextButton.h"
#import "SwithPayTypeView.h"
#import "PayTypeView.h"
#import "BankImageHelper.h"
#import "BindCardViewController.h"
#import "PasswordView.h"
#import "WithdrawResultViewController.h"
#import "ServeForTextField.h"
#import "NetworkingUtils.h"
#import "BankCard.h"
#import "BankCardUtils.h"

@interface TransferAccountToBankViewController ()<UITextFieldDelegate>
{
    dispatch_semaphore_t _semaphore;
}
@property (strong, nonatomic) IBOutlet AuthItem *bankCardNoItem;
@property (strong, nonatomic) IBOutlet AuthItem *nameItem;
@property (strong, nonatomic) IBOutlet AuthItem *amountItem;
@property (strong, nonatomic) IBOutlet UILabel *remindLabel;
@property (strong, nonatomic) IBOutlet NextButton *nextBtn;

@property (strong, nonatomic) IBOutlet SwithPayTypeView *switchPayTypeView;
@property (strong, nonatomic) IBOutlet AuthItem *bankNameItem;
@property (strong, nonatomic) IBOutlet AuthItem *timeItem;
@property (strong, nonatomic) IBOutlet UIView *intervalView;

@property (nonatomic, strong)ServeForTextField *server;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) BankCard *selectBankCard;
@property (nonatomic, strong) BankCard *toBankCard;

@end

@implementation TransferAccountToBankViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
    [self networking];
    
    self.server = [[ServeForTextField alloc] init];
    [self.server startServeFor:self.view];
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
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"转账到银行卡";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.bankCardNoItem.hiddenTop = YES;
    self.bankCardNoItem.hiddenBottom = YES;
    self.bankCardNoItem.titleLabel.text = @"卡号";
    self.bankCardNoItem.textField.placeholder = @"收款人银行卡号";
    self.bankCardNoItem.textField.delegate = self;
    self.bankCardNoItem.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    self.nameItem.hiddenBottom = YES;
    self.nameItem.titleLabel.text = @"姓名";
    self.nameItem.textField.placeholder = @"收款人真实姓名";
    self.nameItem.textField.delegate = self;
    

    
    self.bankNameItem.hiddenBottom = YES;
    self.bankNameItem.titleLabel.text = @"银行";
    self.bankNameItem.textField.text = @"";
    self.bankNameItem.textField.delegate = self;
    self.bankNameItem.textField.placeholder = @"请选择银行";
    
    self.timeItem.hiddenBottom = YES;
    self.timeItem.titleLabel.text = @"时间";
    self.timeItem.textField.text = @"预计2小时内到账";
    self.timeItem.userInteractionEnabled = NO;
    
    self.amountItem.titleLabel.text = @"金额";
    self.amountItem.textField.placeholder = @"请输入转账金额";
    self.amountItem.hiddenTop = YES;
    self.amountItem.textField.delegate = self;
    
    [self.nextBtn setTitle:@"确定转账" forState:UIControlStateNormal];
    
    [self.switchPayTypeView settingPayType:@"招商银行（1224）"];
    
    [self.switchPayTypeView callBack:^{
        [self switchBtnAction];
    }];
    

    [self.bankCardNoItem.textField addTarget:self action:@selector(textfieldValueChange) forControlEvents:UIControlEventEditingChanged];
    [self.nameItem.textField addTarget:self action:@selector(textfieldValueChange) forControlEvents:UIControlEventEditingChanged];
    [self.bankNameItem.textField addTarget:self action:@selector(textfieldValueChange) forControlEvents:UIControlEventEditingChanged];
    [self.timeItem.textField addTarget:self action:@selector(textfieldValueChange) forControlEvents:UIControlEventEditingChanged];
    [self.amountItem.textField addTarget:self action:@selector(textfieldValueChange) forControlEvents:UIControlEventEditingChanged];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    });
    
    [self hiddenBankName];

}

#pragma mark - Get

- (BankCard *)toBankCard{
    if (!_toBankCard) {
        _toBankCard = [[BankCard alloc] init];
    }
    return _toBankCard;
}


#pragma mark - BtnActions

- (void)switchBtnAction{
    
        [self.view endEditing:YES];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (BankCard *bankCard in self.listArray) {
        
        PayTypeModel *model = [[PayTypeModel alloc] init];
        model.title = [NSString stringWithFormat:@"%@(%@)", bankCard.bankName, [BankCardUtils lastFour:bankCard.bankNo]];
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


- (IBAction)nextBtnAction:(id)sender {
    
    PasswordView *passwordView = [[PasswordView alloc] initWithFrame:self.view.bounds];
    [self.navigationController.view addSubview:passwordView];
    
    __weak typeof(self) weakSelf = self;
    
    [passwordView passwordAuthComplete:^(id data) {
        NSLog(@"%@", data);
        
        [weakSelf toTransfer:data];
        
    }];
    
    
    
}

- (IBAction)historyRecordBtnAction:(id)sender {
}

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Networking

- (void)cardBinNetworking{
    
    NSString *url = [kCardInfoQueryUrl stringByAppendingString:self.bankCardNoItem.textField.text];
    [Networking networkingWithHttpOfGetTo:url backData:^(NSData *data) {
        
        if (data.length == 0) {
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *rspCode = jsonDic[@"retCode"];
        
        if ([rspCode isEqualToString:@"Y"]) {
            
            NSDictionary *dataDic = jsonDic[@"data"];
            self.toBankCard.bankCode = dataDic[@"issuerCode"];
            self.toBankCard.cardType = dataDic[@"cardType"];
            self.toBankCard.bankName = dataDic[@"issName"];
            
            self.bankNameItem.textField.text = self.toBankCard.bankName;
            [self showBankName];
            
        }else{
            NSLog(@"卡bin查询失败");
            [PopupAction alertMsg:@"卡bin查询失败" of:self];
        }
        
    }];
    
}

- (void)transferAccountsNetworking{
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    NSString *payType;
    if (self.selectBankCard == nil) {
        payType = @"0";
    }else{
        payType = @"1";
    }
    
    NSDictionary *params = @{@"accountId" : defaultMessage.accountId,
                             @"transferType" : @"1",
                             @"toBankNo" : self.bankCardNoItem.textField.text,
                             @"toBankName" : self.bankNameItem.textField.text,
                             @"toName" : self.nameItem.textField.text,
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
            
            WithdrawResultViewController *resultVC = [[WithdrawResultViewController alloc] init];
            resultVC.resultType = ResultTypeTransferAccount;
            resultVC.dealTime = jsonDic[@"dealTime"];
            [self.navigationController pushViewController:resultVC animated:YES];
            
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
        [self.switchPayTypeView settingPayType:[NSString stringWithFormat:@"账户余额￥%@", defaultMessage.propertyMsg.availableProperty]];
        self.selectBankCard = nil;
    }else{
        NSString *bankNo = [BankCardUtils lastFour:bankCard.bankNo];
        [self.switchPayTypeView settingPayType:[NSString stringWithFormat:@"%@(%@)",bankCard.bankName, bankNo]];
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


- (void)textfieldValueChange{
    
    if (self.bankCardNoItem.textField.text.length > 0 && self.bankNameItem.textField.text.length > 0 && self.nameItem.textField.text.length > 0 && self.timeItem.textField.text.length > 0 && self.amountItem.textField.text.length > 0) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
    
    if (self.bankCardNoItem.textField.text.length > 15) {
        [self cardBinNetworking];
    }else{
        [self hiddenBankName];
    }
    
    
}

- (void)hiddenBankName{
    
    
    self.bankNameItem.hidden = YES;
    self.timeItem.hidden = YES;
    
//        CGRect bankNameItemFrame = self.bankNameItem.frame;
//        bankNameItemFrame.origin.x = kRectWidth;
//        self.bankNameItem.frame = bankNameItemFrame;
    
//    CGRect timeItemFrame = self.timeItem.frame;
//    timeItemFrame.origin.x = kRectWidth;
//    self.timeItem.frame = timeItemFrame;
    
//    CGRect intervalViewFrame = self.intervalView.frame;
//    intervalViewFrame.origin.y = CGRectGetMaxY(self.nameItem.frame);
//    self.intervalView.frame = intervalViewFrame;
    
    [self.bankNameItem mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kRectWidth));
    }];
    
    [self.timeItem mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kRectWidth));
    }];

    [self.intervalView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameItem.mas_bottom);
    }];
    

//    [self toChangeFrame];
}

- (void)showBankName{
    
    self.bankNameItem.hidden = NO;
    self.timeItem.hidden = NO;
    
//    CGRect bankNameItemFrame = self.bankNameItem.frame;
//    bankNameItemFrame.origin.x = 0;
//    self.bankNameItem.frame = bankNameItemFrame;
//
//    CGRect timeItemFrame = self.timeItem.frame;
//    timeItemFrame.origin.x = 0;
//    self.timeItem.frame = timeItemFrame;
//
//    CGRect intervalViewFrame = self.intervalView.frame;
//    intervalViewFrame.origin.y = CGRectGetMaxY(self.timeItem.frame);
//    self.intervalView.frame = intervalViewFrame;
    
    
    [self.bankNameItem mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.right.equalTo(@0);
        make.height.equalTo(@50);
        make.top.equalTo(self.nameItem.mas_bottom);
    }];
    
    [self.timeItem mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.right.equalTo(@0);
        make.height.equalTo(@50);
        make.top.equalTo(self.bankNameItem.mas_bottom);
    }];
    
    [self.intervalView mas_remakeConstraints:^(MASConstraintMaker *make) {
    
        make.top.equalTo(self.timeItem.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@15);
    }];
    
    
    
}

- (void)toChangeFrame{
    
    
    CGRect amountItemFrame = self.amountItem.frame;
    amountItemFrame.origin.y = CGRectGetMaxY(self.intervalView.frame);
    self.amountItem.frame = amountItemFrame;
    
    
    CGRect remindLabelFrame = self.remindLabel.frame;
    remindLabelFrame.origin.y = CGRectGetMaxY(self.amountItem.frame) + 5;
    self.remindLabel.frame = remindLabelFrame;
    
    CGRect nextBtnFrame = self.nextBtn.frame;
    nextBtnFrame.origin.y = CGRectGetMaxY(self.amountItem.frame) + 73;
    self.nextBtn.frame = nextBtnFrame;
    
    CGRect switchPayTypeViewFrame = self.switchPayTypeView.frame;
    switchPayTypeViewFrame.origin.y = CGRectGetMaxY(self.nextBtn.frame) + 10;
    self.switchPayTypeView.frame = switchPayTypeViewFrame;
    
    [self.view layoutIfNeeded];

    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.server currentTextField:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == self.bankCardNoItem.textField){
        [self.nameItem.textField becomeFirstResponder];
    }else if (textField == self.nameItem.textField){
        [self.amountItem.textField becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    return YES;
}

@end
