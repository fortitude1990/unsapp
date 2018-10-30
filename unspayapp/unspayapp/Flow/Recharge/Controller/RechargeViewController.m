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
    
    switch (self.tradingType) {
        case TradingTypeRecharge:
            self.navigationItem.title = @"账户充值";
            self.allWithdrawBtn.hidden = YES;
            break;
        case TradingTypeWithdraw:
            self.navigationItem.title = @"余额提现";
            self.remindLabel.text = @"可用余额XXXX";
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
    
    
}

- (void)tapGesAction{
    
    [self.view endEditing:YES];
    
    switch (self.tradingType) {
        case TradingTypeRecharge:
            [self rechargeType];
            break;
        case TradingTypeWithdraw:
            [self withdrawType];
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
    
    PasswordView *passwordView = [[PasswordView alloc] initWithFrame:self.view.bounds];
    [self.navigationController.view addSubview:passwordView];
    
    __weak typeof(self) weakSelf = self;
    
    [passwordView passwordAuthComplete:^(id data) {
        NSLog(@"%@", data);
        
        switch (weakSelf.tradingType) {
            case TradingTypeRecharge:
            {
                RechargeSuccessViewController *successVC = [[RechargeSuccessViewController alloc] init];
                [weakSelf.navigationController pushViewController:successVC animated:YES];
                break;
            }
            case TradingTypeWithdraw:
            {
                WithdrawResultViewController *withdrawResultVc = [[WithdrawResultViewController alloc] init];
                [weakSelf.navigationController pushViewController:withdrawResultVc animated:YES];
                break;
            }
            default:
                break;
        }
        

        
        
    }];
}

#pragma mark - Methods

- (void)loadData{
    
    
    if (self.listArray.count > 0) {
        
    }else{
        self.bankNameLabel.text = @"";
        self.bankNoLabel.text = @"";
        self.bankTypeLabel.text = @"";
    }
    
}

- (void)rechargeType{
    
    PayTypeModel *model = [[PayTypeModel alloc] init];
    model.title = @"中国工商银行(6442)";
    model.imageName = [BankImageHelper gainRealImageName:@"中国工商银行"];
    
    PayTypeModel *model1 = [[PayTypeModel alloc] init];
    model1.imageName =[BankImageHelper gainRealImageName:@"上海银行"];
    model1.title = @"上海银行(9996)";
    
    PayTypeModel *model2 = [[PayTypeModel alloc] init];
    model2.imageName =[BankImageHelper gainRealImageName:@"上海浦东发展银行"];
    model2.title = @"上海浦东发展银行(9996)";

    
    PayTypeModel *payType = [[PayTypeModel alloc] init];
    payType.imageName = @"添加新卡";
    payType.title = @"使用新银行卡";
    payType.selectImageName = @"右箭头";
    payType.type = PayTypeModelTypeUseNewBank;
    
    NSArray *array = @[model,model1,model2,payType];
    
    
    PayTypeView *payTypeView = [[PayTypeView alloc] init];
    payTypeView.elementsArray = array;
    [self.tabBarController.view addSubview:payTypeView];
    [payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(@0);
    }];
    
    [payTypeView show];
    
}

- (void)withdrawType{
    
    WithdrawBankListViewController *bankListVC = [[WithdrawBankListViewController alloc] init];
    [self.navigationController pushViewController:bankListVC animated:YES];
    
    
}

- (void)textFieldValueChange{
    
    if (self.amountTF.text.length > 0) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
    
}

#pragma mark - Networking

- (void)networking{
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    NSDictionary *params = @{@"accountId" : defaultMessage.accountId};
    
    [Networking networkingWithHTTPOfPostTo:kBankListUrl params:params backData:^(NSData *data) {
        
        if (data.length == 0) {
            [PopupAction alertMsg:@"无法连接服务器，请稍后重试" of:nil];
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *rspCode = jsonDic[@"rspCode"];
        
        if ([rspCode isEqualToString:@"0000"]) {
            
            NSArray *array = jsonDic[@"list"];
            self.listArray = [NSArray arrayWithArray:array];
            [self loadData];
            
        }else{
            NSString *rspMsg = jsonDic[@"rspMsg"];
            NSLog(@"%@", rspMsg);
            [PopupAction alertMsg:rspMsg of:self];
        }
        
        
    }];
    
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

@end
