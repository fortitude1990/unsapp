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
    
    PasswordView *passwordView = [[PasswordView alloc] initWithFrame:self.view.bounds];
    [self.navigationController.view addSubview:passwordView];
    [passwordView passwordAuthComplete:^(id data) {
        NSLog(@"%@", data);
    }];
}

#pragma mark - Methods

- (void)rechargeType{
    
    PayTypeModel *model = [[PayTypeModel alloc] init];
    model.imageName = @"中国工商银行";
    model.title = @"中国工商银行(6442)";
    
    PayTypeModel *model1 = [[PayTypeModel alloc] init];
    model1.imageName = @"宁波银行";
    model1.title = @"宁波银行(9996)";
    
    NSArray *array = @[model,model1];
    
    
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

@end
