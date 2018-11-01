//
//  WithdrawResultViewController.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, ResultType) {
    ResultTypeWithdraw,
    ResultTypeTransferAccount,
};

@interface WithdrawResultViewController : BaseViewController

@property (nonatomic, assign)ResultType resultType;

@property (nonatomic, strong) NSString *dealTime;

@end
