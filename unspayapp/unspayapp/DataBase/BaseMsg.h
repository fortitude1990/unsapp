//
//  BaseMsg.h
//  unspayapp
//
//  Created by 李志敬 on 2018/10/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseMsg : NSObject<NSCoding>

@property (nonatomic, strong) NSString *name; //姓名
@property (nonatomic, strong) NSString *sex; //性别
@property (nonatomic, strong) NSString *birthday; //生日
@property (nonatomic, strong) NSString *nickname; //昵称
@property (nonatomic, strong) NSString *email; //邮箱
@property (nonatomic, strong) NSString *headPortraitImage; //头像
@property (nonatomic, strong) NSString *constellation; //星座
@property (nonatomic, strong) NSString *height; //身高
@property (nonatomic, strong) NSString *weight; //体重
@property (nonatomic, strong) NSString *region; //地区
@property (nonatomic, strong) NSString *professional; //职业
@property (nonatomic, strong) NSString *income; //收入
@property (nonatomic, strong) NSString *isSettingGesture; //是否设置手势
@property (nonatomic, strong) NSString *isSettingPwd; //是否设置密码
@property (nonatomic, strong) NSString *isRealName; //是否实名认证
@property (nonatomic, strong) NSString *isSetPayPwd; //是否设置支付密码

@end

NS_ASSUME_NONNULL_END
