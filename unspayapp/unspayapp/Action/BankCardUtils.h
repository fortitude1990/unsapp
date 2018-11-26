//
//  BankCardUtils.h
//  unspayapp
//
//  Created by 李志敬 on 2018/10/31.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankCardUtils : NSObject

+ (NSString *)reservedLastFourAndNeat:(NSString *)bankNo;
+ (NSString *)lastFour:(NSString *)bankNo;
+ (NSString *)recessiveTel:(NSString *)tel;

@end

NS_ASSUME_NONNULL_END
