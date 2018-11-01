//
//  DateFormatUtils.h
//  unspayapp
//
//  Created by 李志敬 on 2018/10/31.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateFormatUtils : NSObject

+ (NSString *)dateString: (NSString *)dateString originalFormat:(NSString *)originalFormat transferToFormat:(NSString *)transferToFormat;
@end

NS_ASSUME_NONNULL_END
