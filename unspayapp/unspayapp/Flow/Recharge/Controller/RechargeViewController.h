//
//  RechargeViewController.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, TradingType) {
    TradingTypeRecharge,
    TradingTypeWithdraw,
};

@interface RechargeViewController : BaseViewController

@property (nonatomic, assign)TradingType tradingType;

@end
