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



@interface TransferAccountToWalletMessageViewController ()<UITextViewDelegate, UITextFieldDelegate>;

@property (strong, nonatomic) IBOutlet AuthItem *accountItem;
@property (strong, nonatomic) IBOutlet AuthItem *nameItem;
@property (strong, nonatomic) IBOutlet AuthItem *amountItem;
@property (strong, nonatomic) IBOutlet AuthItem *remarkItem;
@property (strong, nonatomic) IBOutlet UILabel *serverLabel;
@property (strong, nonatomic) IBOutlet NextButton *nextBtn;
@property (strong, nonatomic) IBOutlet UITextView *switchPayTypeTextView;

@end

@implementation TransferAccountToWalletMessageViewController

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

- (void)createUI{
    
    self.navigationItem.title = @"转账到个人钱包账户";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    self.accountItem.titleLabel.text = @"对方账户";
    self.accountItem.textField.text = @"13526657140";
    self.accountItem.textField.userInteractionEnabled = NO;
    self.accountItem.hiddenTop = YES;
    
    self.nameItem.titleLabel.text = @"姓名";
    self.nameItem.textField.text = @"李磨";
    self.nameItem.textField.userInteractionEnabled = NO;
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
    
    [self.amountItem.textField addTarget:self action:@selector(textfieldValueChange) forControlEvents:UIControlEventTouchUpInside];
    [self.remarkItem.textField addTarget:self action:@selector(textfieldValueChange) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"使用招商银行（1224）付款，更换"];
    [attributedString addAttribute:NSLinkAttributeName
                                        value:@"switch://"
                                        range:[[attributedString string] rangeOfString:@"更换"]];
    self.switchPayTypeTextView.attributedText = attributedString;
    self.switchPayTypeTextView.linkTextAttributes = @{
                                                      NSForegroundColorAttributeName: KHexColor(0x0068b7),
                                                     
                                                      NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                                    
                                                      NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    self.switchPayTypeTextView.delegate = self;
    self.switchPayTypeTextView.editable = NO;
    self.switchPayTypeTextView.scrollEnabled = NO;
    self.switchPayTypeTextView.textAlignment = NSTextAlignmentCenter;
}

- (void)loadData{
    
}

- (void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchBank{
    
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
    payType1.imageName = @"添加新卡";
    payType1.title = @"账户余额\n可用余额0.00元";
    payType1.type = PayTypeModelTypeBalanceShow;
    
    NSArray *array = @[model,model1,model2,payType,payType1];
    
    PayTypeView *payTypeView = [[PayTypeView alloc] init];
    payTypeView.elementsArray = array;
    [self.tabBarController.view addSubview:payTypeView];
    [payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(@0);
    }];
    
    [payTypeView show];
    
    
}
- (IBAction)nextBtnAction:(id)sender {
    
    PasswordView *passwordView = [[PasswordView alloc] initWithFrame:self.view.bounds];
    [self.navigationController.view addSubview:passwordView];
    
    __weak typeof(self) weakSelf = self;
    
    [passwordView passwordAuthComplete:^(id data) {
        
        RechargeSuccessViewController *successVC = [[RechargeSuccessViewController alloc] init];
        successVC.type = SuccessTypeTransferAccount;
        [weakSelf.navigationController pushViewController:successVC animated:YES];
        
    }];
    
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
