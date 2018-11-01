//
//  WithdrawResultViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "WithdrawResultViewController.h"
#import "DateFormatUtils.h"

@interface WithdrawResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *applicationTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UILabel *finalTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitleLabel;

@end

@implementation WithdrawResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.navigationController.navigationBar.hidden = YES;
    self.nextBtn.layer.cornerRadius = kAutoScaleNormal(6);
    self.nextBtn.clipsToBounds = YES;
    
    if(self.resultType == ResultTypeTransferAccount){
        self.finalTitleLabel.text = @"转账结果";
        self.navigationTitleLabel.text = @"转账结果";
    }
    
    if (self.dealTime) {
        NSString *dateString = [DateFormatUtils dateString:self.dealTime originalFormat:@"yyyyMMddHHmmss" transferToFormat:@"MM-dd HH:mm"];
        self.applicationTimeLabel.text = dateString;
        self.dealTimeLabel.text = dateString;
    }
    
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
- (IBAction)nextBtnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
