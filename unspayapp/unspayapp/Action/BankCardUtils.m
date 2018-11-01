//
//  BankCardUtils.m
//  unspayapp
//
//  Created by 李志敬 on 2018/10/31.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BankCardUtils.h"

@implementation BankCardUtils

+ (NSString *)reservedLastFourAndNeat:(NSString *)aBankNo{
    
    int length = aBankNo.length % 4;
    if (aBankNo.length % 4 == 0) {
        length = 4;
    }
    
    NSMutableString *replaceString = [NSMutableString stringWithString:@"*"];
    for (int i = 1; i < aBankNo.length - length; i ++) {
        replaceString = [NSMutableString stringWithString:[replaceString stringByAppendingString:@"*"]];
    }
    NSString *bankNo = [aBankNo stringByReplacingCharactersInRange:NSMakeRange(0, aBankNo.length - length) withString:replaceString];
    NSMutableString *newBankNo = [NSMutableString stringWithString:bankNo];
    int j = 0;
    for (int i = 0; i < bankNo.length - 1; i++) {
        if (i % 4 == 0) {
            [newBankNo insertString:@" " atIndex: i + j];
            j ++;
        }
    }
    
    return newBankNo;
}

+ (NSString *)lastFour:(NSString *)bankNo{
    if (bankNo.length <= 4) {
        return bankNo;
    }
    NSString *subString = [bankNo substringFromIndex:bankNo.length - 4];
    return subString;
}

@end
