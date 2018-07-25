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
    self.bankNameItem.textField.text = @"光大银行";
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



#pragma mark - BtnActions

- (void)switchBtnAction{
    
        [self.view endEditing:YES];
        
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
        
        PayTypeModel *payType1 = [[PayTypeModel alloc] init];
        payType1.imageName = @"账户余额灰";
        payType1.title = @"账户余额\n可用余额0.00元";
        payType1.type = PayTypeModelTypeBalanceShow;
        
        PayTypeModel *payType2 = [[PayTypeModel alloc] init];
        payType2.imageName = @"账户余额";
        payType2.title = @"账户余额\n可用余额3999.30元";
        payType2.type = PayTypeModelTypeUseBalance;
        
        NSArray *array = @[model,model1,model2,payType,payType1,payType2];
        
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
                    [self.switchPayTypeView settingPayType:@"账户余额39.33"];
                    break;
                case PayTypeModelTypeDefault:
                    [self.switchPayTypeView settingPayType:payTypeModel.title];
                    break;
                case PayTypeModelTypeUseNewBank:
                    [self toBindBankCard];
                    break;
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
    
}

- (IBAction)nextBtnAction:(id)sender {
    
    PasswordView *passwordView = [[PasswordView alloc] initWithFrame:self.view.bounds];
    [self.navigationController.view addSubview:passwordView];
    
    __weak typeof(self) weakSelf = self;
    
    [passwordView passwordAuthComplete:^(id data) {
        NSLog(@"%@", data);
        
        WithdrawResultViewController *resultVC = [[WithdrawResultViewController alloc] init];
        resultVC.resultType = ResultTypeTransferAccount;
        [weakSelf.navigationController pushViewController:resultVC animated:YES];
        
    }];
    
    
    
}

- (IBAction)historyRecordBtnAction:(id)sender {
}

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Methods


- (void)textfieldValueChange{
    
    if (self.bankCardNoItem.textField.text.length > 0 && self.bankNameItem.textField.text.length > 0 && self.nameItem.textField.text.length > 0 && self.timeItem.textField.text.length > 0 && self.amountItem.textField.text.length > 0) {
        [self.nextBtn canResponse];
    }else{
        [self.nextBtn noResponse];
    }
    
    if (self.bankCardNoItem.textField.text.length > 5) {
        [self showBankName];
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
