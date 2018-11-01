//
//  BankCard.h
//  unspayapp
//
//  Created by 李志敬 on 2018/10/29.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankCard : NSObject

@property (nonatomic, strong) NSString *bankNo;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankCode;
@property (nonatomic, strong) NSString *bankAboutMobile;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cardType;


@end

NS_ASSUME_NONNULL_END
