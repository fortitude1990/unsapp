//
//  RechargeViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RechargeViewController.h"
#import "ItemBackView.h"
#import "NextButton.h"
#import "PayTypeView.h"
#import "PasswordView.h"
#import "WithdrawBankListViewController.h"
#import "BankImageHelper.h"
#import "RechargeSuccessViewController.h"
#import "WithdrawResultViewController.h"
#import "NetworkingUtils.h"
#import "BindCardViewController.h"
#import "BankCard.h"
#import "BankCardUtils.h"

@interface RechargeViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *bankImageView;
@property (strong, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *bankNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *bankTypeLabel;
@property (strong, nonatomic) IBOutlet ItemBackView *bankItem;
@property (strong, nonatomic) IBOutlet UITextField *amountTF;
@property (strong, nonatomic) IBOutlet UILabel *serveAmountLabel;
@property (strong, nonatomic) IBOutlet NextButton *nextBtn;
@property (strong, nonatomic) IBOutlet UILabel *remindLabel;
@property (strong, nonatomic) IBOutlet UIButton *allWithdrawBtn;
@property (strong, nonatomic) BankCard *selectBankCard;

@property (strong, nonatomic) NSArray *listArray;

@end

@implementation RechargeViewController

#pragma mark - LifeCycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden =  NO;
    
}

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
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    
    switch (self.tradingType) {
        case TradingTypeRecharge:
            self.navigationItem.title = @"账户充值";
            self.allWithdrawBtn.hidden = YES;
            break;
        case TradingTypeWithdraw:
            self.navigationItem.title = @"余额提现";
            self.remindLabel.text = [NSString stringWithFormat:@"可用余额%@元", defaultMessage.propertyMsg.availableProperty];
            break;
        default:
            break;
    }
    
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.amountTF.delegate = self;
    [self.amountTF addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction)];
    [_bankItem addGestureRecognizer:tapGes];
    
}

#pragma mark - BtnActions

- (IBAction)allWithdrawBtnAction:(id)sender {
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    if ([defaultMessage.propertyMsg.availableProperty floatValue] > 0) {
        self.amountTF.text = defaultMessage.propertyMsg.availableProperty;
        [self textFieldValueChange];
    }

}

- (void)tapGesAction{
    
    [self.view endEditing:YES];
    
    switch (self.tradingType) {
        case TradingTypeRecharge:
            if (![self.listArray isEqual:[NSNull null]] && self.listArray != nil && self.listArray.count > 0) {
                [self rechargeType];
            }else{
                [self toBindBankCard];
            }
            break;
        case TradingTypeWithdraw:
            if (![self.listArray isEqual:[NSNull null]] && self.listArray != nil && self.listArray.count > 0) {
                [self withdrawType];
            }else{
                [self toBindBankCard];
            }
            break;
        default:
            break;
    }
    
    
}

-(void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)nextBtnAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.selectBankCard == nil) {
        [[PopupAction defaultPopupAction] popupWithTitle:@"温馨提示" message:@"您还未绑定银行卡，是否进行绑卡" ok:@"再看看" cancel:@"去绑定" okAction:nil cancelAction:^{
            [self toBindBankCard];
        } of:self];
        return;
    }
    
    
    PasswordView *passwordView = [[PasswordView alloc] initWithFrame:self.view.bounds];
    [self.navigationController.view addSubview:passwordView];
    
    __weak typeof(self) weakSelf = self;
    
    [passwordView passwordAuthComplete:^(id data) {
        NSLog(@"%@", data);
        
        switch (weakSelf.tradingType) {
            case TradingTypeRecharge:
            {
                [self toRecharge:data];
                break;
            }
            case TradingTypeWithdraw:
            {
                [self toWithdraw:data];
                break;
            }
            default:
                break;
        }
        

        
        
    }];
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

#pragma mark - Methods

- (void)toSetSelectBankCard: (BankCard *)bankCard{

    if (bankCard == nil) {
        self.bankNameLabel.text = @"";
        self.bankNoLabel.text = @"";
        self.bankTypeLabel.text = @"";
        self.selectBankCard = nil;
    }else{
        

        self.bankNoLabel.text = [BankCardUtils reservedLastFourAndNeat:bankCard.bankNo];
        
        self.bankNameLabel.text = bankCard.bankName;
        if ([bankCard.cardType isEqualToString:@"0"]) {
            self.bankTypeLabel.text = @"储蓄卡";
        }else{
            self.bankTypeLabel.text = @"信用卡";
        }
        self.bankImageView.image = [BankImageHelper gainImage:bankCard.bankName];
        self.selectBankCard = bankCard;
    }

    
}

- (void)loadData{
    
    if (self.listArray != nil && self.listArray.count > 0) {
        BankCard *bankCard = self.listArray.firstObject;
        [self toSetSelectBankCard:bankCard];
    }else{
        [self toSetSelectBankCard:nil];
    }
    
}

- (void)rechargeType{
    

    NSMutableArray *array = [NSMutableArray array];
    
    for (BankCard *bankCard in self.listArray) {
        
        NSString *lastBankNo = [bankCard.bankNo substringFromIndex:bankCard.bankNo.length - 4];
        PayTypeModel *model = [[PayTypeModel alloc] init];
        model.title = [NSString stringWithFormat:@"%@(%@)", bankCard.bankName, lastBankNo];
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
    
    
    PayTypeView *payTypeView = [[PayTypeView alloc] init];
    payTypeView.elementsArray = array;
    [self.tabBarController.view addSubview:payTypeView];
    [payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(@0);
    }];
    
    [payTypeView show];
    [payTypeView callBack:^(PayTypeModel *payTypeModel) {
        
        if (payTypeModel.type == PayTypeModelTypeUseNewBank) {
            [self toBindBankCard];
        }else{
            [self toSetSelectBankCard:payTypeModel.params];
        }
        
    }];
    
}

- (void)withdrawType{
    
    WithdrawBankListViewController *bankListVC = [[WithdrawBankListViewController alloc] init];
    bankListVC.listArray = self.listArray;
    bankListVC.selectBankCard = self.selectBankCard;
    [bankListVC callback:^(BOOL isUpdateBankList, NSString *message, BankCard *returnParams) {
        if (isUpdateBankList) {
            [self networking];
        }
        if (returnParams) {
            [self toSetSelectBankCard:returnParams];
        }
    }];
    [self.navigationController pushViewController:bankListVC animated:YES];
    
    
}

- (void)textFieldValueChange{
    
    if (self.amountTF.text.length > 0) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
    
}

- (void)toRecharge: (NSString *)pwd{
    
    [ProgressHUB show];
    
    [self verifyPayPwd:pwd networking:^(BOOL flag, NSString *message) {
        
        if (flag) {
            [self toRechargeNetworking];
        }else{
            [ProgressHUB dismiss];
            [PopupAction alertMsg:message of:self];
        }
        
    }];
    
}

- (void)toWithdraw: (NSString *)pwd{
    
    [ProgressHUB show];
    
    [self verifyPayPwd:pwd networking:^(BOOL flag, NSString *message) {
        
        if (flag) {
            [self toWithdrawNetworking];
        }else{
            [ProgressHUB dismiss];
            [PopupAction alertMsg:message of:self];
        }
        
    }];
    
}


#pragma mark - Networking

- (void)toWithdrawNetworking{
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    NSDictionary *params = @{@"accountId" : defaultMessage.accountId,
                             @"toBankNo" : self.selectBankCard.bankNo,
                             @"amount" : self.amountTF.text,
                             @"toBankName" : self.selectBankCard.bankName
                             };
    
    [Networking networkingWithHTTPOfPostTo:kWithdrawUrl params:params backData:^(NSData *data) {
        
        [ProgressHUB dismiss];
        
        if (data.length == 0) {
            [PopupAction alertMsg:@"无法连接服务器，请稍后重试" of:self];
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *rspCode = jsonDic[@"rspCode"];
        if ([rspCode isEqualToString:@"0000"]) {
            
            defaultMessage.isUpdateBaseMsg = YES;
            WithdrawResultViewController *withdrawResultVc = [[WithdrawResultViewController alloc] init];
            withdrawResultVc.dealTime = jsonDic[@"dealTime"];
            [self.navigationController pushViewController:withdrawResultVc animated:YES];
            
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

- (void)toRechargeNetworking{
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    NSDictionary *params = @{@"accountId" : defaultMessage.accountId,
                             @"bankNo" : self.selectBankCard.bankNo,
                             @"amount" : self.amountTF.text
                             };
    
    [Networking networkingWithHTTPOfPostTo:kRechargeUrl params:params backData:^(NSData *data) {
        
        [ProgressHUB dismiss];
        
        if (data.length == 0) {
            [PopupAction alertMsg:@"无法连接服务器，请稍后重试" of:self];
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *rspCode = jsonDic[@"rspCode"];
        if ([rspCode isEqualToString:@"0000"]) {
            
            defaultMessage.isUpdateBaseMsg = YES;
                RechargeSuccessViewController *successVC = [[RechargeSuccessViewController alloc] init];
            successVC.amount = self.amountTF.text;
            successVC.bankCard = self.selectBankCard;
                [self.navigationController pushViewController:successVC animated:YES];
            
        }else{
            NSString *rspMsg = jsonDic[@"rspMsg"];
            NSLog(@"%@", rspMsg);
            [PopupAction alertMsg:rspMsg of:self];
        }
        
        
        
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
                self.listArray = [NSArray arrayWithArray:returnParams];
            }
            
            if(!self.selectBankCard){
                [self loadData];
            }
            
        }else{
            [PopupAction alertMsg:message of:self];
        }
        
    }];
    
    
}




#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

@end
