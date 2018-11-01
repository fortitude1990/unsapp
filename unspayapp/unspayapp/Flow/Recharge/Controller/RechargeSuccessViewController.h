//
//  RechargeSuccessViewController.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, SuccessType) {
    SuccessTypePay,
    SuccessTypeTransferAccount,
};

@class BankCard;
@interface RechargeSuccessViewController : BaseViewController

@property (nonatomic, assign)SuccessType type;

@property (nonatomic, strong) NSString *amount;

@property (nonatomic, strong) BankCard *bankCard;

@end
