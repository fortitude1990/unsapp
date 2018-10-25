//
//  PropertyMsg.h
//  unspayapp
//
//  Created by 李志敬 on 2018/10/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface PropertyMsg : NSObject

@property (nonatomic, strong) NSString *totalProperty; //总资产
@property (nonatomic, strong) NSString *availableProperty; //可用资产
@property (nonatomic, strong) NSString *monthlySpending; //月支出
@property (nonatomic, strong) NSString *monthlyIncome; //月收入


@end

NS_ASSUME_NONNULL_END
