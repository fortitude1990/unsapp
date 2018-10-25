//
//  BaseMsg.m
//  unspayapp
//
//  Created by 李志敬 on 2018/10/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BaseMsg.h"





@implementation BaseMsg


- (void)encodeWithCoder:(NSCoder *)aCoder{
    
   [aCoder encodeObject:self.name forKey:@"name"]; //姓名
   [aCoder encodeObject:self.sex forKey:@"sex"]; //性别
   [aCoder encodeObject:self.birthday forKey:@"birthday"]; //生日
   [aCoder encodeObject:self.nickname forKey:@"nickname"]; //昵称
   [aCoder encodeObject:self.email forKey:@"email"]; //邮箱
   [aCoder encodeObject:self.headPortraitImge forKey:@"headPortraitImge"]; //头像
   [aCoder encodeObject:self.constellation forKey:@"constellation"]; //星座
   [aCoder encodeObject:self.height forKey:@"height"]; //身高
   [aCoder encodeObject:self.weight forKey:@"weight"]; //体重
   [aCoder encodeObject:self.region forKey:@"region"]; //地区
   [aCoder encodeObject:self.professional forKey:@"professional"]; //职业
    [aCoder encodeObject:self.income forKey:@"income"]; //收入
    [aCoder encodeObject:self.isSettingGesture forKey:@"isSettingGesture"]; //是否设置手势
    [aCoder encodeObject:self.isSettingPwd forKey:@"isSettingPwd"]; //是否设置密码
    [aCoder encodeObject:self.isRealName forKey:@"isRealName"]; //是否实名认证
    [aCoder encodeObject:self.isSetPayPwd forKey:@"isSetPayPwd"]; //是否设置支付密码
    
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        self.name = [coder decodeObjectForKey:@"name"];
        self.sex = [coder decodeObjectForKey:@"sex"];
        self.birthday = [coder decodeObjectForKey:@"birthday"];
        self.nickname = [coder decodeObjectForKey:@"nickname"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.headPortraitImge = [coder decodeObjectForKey:@"headPortraitImge"];
        self.constellation = [coder decodeObjectForKey:@"constellation"];
        self.height = [coder decodeObjectForKey:@"height"];
        self.weight = [coder decodeObjectForKey:@"weight"];
        self.region = [coder decodeObjectForKey:@"region"];
        self.professional = [coder decodeObjectForKey:@"professional"];
        self.income = [coder decodeObjectForKey:@"income"];
        self.isSettingGesture = [coder decodeObjectForKey:@"isSettingGesture"];
        self.isSettingPwd = [coder decodeObjectForKey:@"isSettingPwd"];
        self.isRealName = [coder decodeObjectForKey:@"isRealName"];
        self.isSetPayPwd = [coder decodeObjectForKey:@"isSetPayPwd"];

    }
    return self;
}


@end
