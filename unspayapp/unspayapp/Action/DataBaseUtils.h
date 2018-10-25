//
//  DataBaseUtils.h
//  unspayapp
//
//  Created by 李志敬 on 2018/10/25.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataBaseUtils : NSObject

+ (BOOL)archiverBaseMsg;
+ (BaseMsg *)unArchiverBaseMsg;
+ (BOOL)archiverPropertyMsg;
+ (PropertyMsg *)unArchiverPropertyMsg;

@end

NS_ASSUME_NONNULL_END
