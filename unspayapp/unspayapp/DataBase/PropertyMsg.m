//
//  PropertyMsg.m
//  unspayapp
//
//  Created by 李志敬 on 2018/10/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PropertyMsg.h"

@implementation PropertyMsg

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.totalProperty forKey:@"totalProperty"]; //总资产
    [coder encodeObject:self.availableProperty forKey:@"availableProperty"]; //可用资产
    [coder encodeObject:self.yesterdaySpending forKey:@"yesterdaySpending"]; //昨日支出
    [coder encodeObject:self.yesterdayIncome forKey:@"yesterdayIncome"]; //昨日收入
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super  init];
    if (self) {
        self.totalProperty = [coder decodeObjectForKey:@"totalProperty"];
        self.availableProperty = [coder decodeObjectForKey:@"availableProperty"];
        self.yesterdaySpending = [coder decodeObjectForKey:@"yesterdaySpending"];
        self.yesterdayIncome = [coder decodeObjectForKey:@"yesterdayIncome"];
    }
    return self;
}



@end
