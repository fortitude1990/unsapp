//
//  DefaultMessage.h
//  unspayapp
//
//  Created by 李志敬 on 2018/10/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseMsg.h"
#import "PropertyMsg.h"

NS_ASSUME_NONNULL_BEGIN

@interface DefaultMessage : NSObject

@property (nonatomic, strong) NSString *accountId; //账号id

@property (nonatomic, strong) BaseMsg *baseMsg;
@property (nonatomic, strong) PropertyMsg *propertyMsg;
@property (nonatomic, assign) BOOL isUpdateBaseMsg;


+ (DefaultMessage *)shareMessage;



@end

NS_ASSUME_NONNULL_END
