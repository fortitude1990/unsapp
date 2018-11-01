//
//  DateFormatUtils.m
//  unspayapp
//
//  Created by 李志敬 on 2018/10/31.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "DateFormatUtils.h"

@implementation DateFormatUtils

+ (NSString *)dateString:(NSString *)dateString originalFormat:(NSString *)originalFormat transferToFormat:(NSString *)transferToFormat{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = originalFormat;
    NSDate *date = [formatter dateFromString:dateString];
    formatter.dateFormat = transferToFormat;
    NSString *newDateString = [formatter stringFromDate:date];

    return newDateString;
}

@end
