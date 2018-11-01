//
//  RechargeSuccessViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RechargeSuccessViewController.h"
#import "RechargeRecordViewController.h"
#import "BankCard.h"

@interface RechargeSuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UILabel *bankTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountTitleLabel;

@end

@implementation RechargeSuccessViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.type == SuccessTypePay) {
        self.navigationController.navigationBar.hidden = YES;
    }
    
    
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.type == SuccessTypePay) {
        self.navigationController.navigationBar.hidden = NO;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
    [self loadData];
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
    
    self.bankNameLabel.adjustsFontSizeToFitWidth = YES;
    self.bankNameLabel.minimumScaleFactor = 0.2;
    
    self.nextBtn.layer.cornerRadius = kAutoScaleNormal(6);
    self.nextBtn.clipsToBounds = YES;
    
    switch (self.type) {
        case SuccessTypeTransferAccount:
            self.navigationItem.title = @"转账详情";
//            self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
            break;
            
        default:
            break;
    }
    
    
}

- (void)loadData{
    
    NSString *lastBankNo = [self.bankCard.bankNo substringFromIndex:self.bankCard.bankNo.length - 4];
    NSString *cardType;
    if ([self.bankCard.cardType isEqualToString:@"0"]) {
        cardType = @"储蓄卡";
    }else{
        cardType = @"信用卡";
    }
    self.bankNameLabel.text = [NSString stringWithFormat:@"%@ %@ (%@)", self.bankCard.bankName, cardType, lastBankNo];
    self.amountLabel.text = [@"￥" stringByAppendingString:self.amount];
    
}



- (IBAction)rechargeRecordBtnAction:(id)sender {
    
    RechargeRecordViewController *recordVC = [[RechargeRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
    
}

- (IBAction)nextBtnAction:(id)sender {
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)leftBtnAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
