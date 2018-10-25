//
//  NetworkingUtils.h
//  unspayapp
//
//  Created by 李志敬 on 2018/10/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkingUtils : NSObject

+ (void)baseMsgNetworking: (CommonBlock) complete;
+ (void)propertyNetworking: (CommonBlock) complete;

@end

NS_ASSUME_NONNULL_END
