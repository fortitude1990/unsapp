//
//  Deal.h
//  unspayapp
//
//  Created by 李志敬 on 2018/10/31.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Deal : NSObject

@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *bankNo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *toAccountId;
@property (nonatomic, strong) NSString *toBankNo;
@property (nonatomic, strong) NSString *toName;
@property (nonatomic, strong) NSString *dealType;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) NSString *transferType;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *toBankName;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *toTel;

@end

NS_ASSUME_NONNULL_END
