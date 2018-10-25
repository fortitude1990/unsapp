//
//  DefaultMessage.m
//  unspayapp
//
//  Created by 李志敬 on 2018/10/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "DefaultMessage.h"

@implementation DefaultMessage

+ (DefaultMessage *)shareMessage{
    static DefaultMessage *defaultMessage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultMessage = [[DefaultMessage alloc] init];
    });
    return defaultMessage;
}

@end
