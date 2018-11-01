//
//  WithdrawBankListViewController.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BaseViewController.h"

@class BankCard;
@interface WithdrawBankListViewController : BaseViewController

@property (nonatomic, strong) NSArray *listArray;

@property (nonatomic, strong) BankCard *selectBankCard;

- (void)callback: (ReturnBlock)callback;

@end
