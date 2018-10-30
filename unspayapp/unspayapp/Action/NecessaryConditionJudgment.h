//
//  NecessaryConditionJudgment.h
//  unspayapp
//
//  Created by 李志敬 on 2018/10/29.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NecessaryConditionJudgment : NSObject

+ (void)promptAndDoRealName:(id)sender;
+ (void)toRealName:(id)sender;
+ (BOOL)checkIsRealName;

+ (void)promptAndDoSetPayPwd:(id)sender;
+ (void)toSetPayPwd:(id)sender;
+ (BOOL)checkIsSetPayPwd;

@end

NS_ASSUME_NONNULL_END
