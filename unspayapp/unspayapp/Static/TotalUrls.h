//
//  TotalUrls.h
//  unspayapp
//
//  Created by 李志敬 on 2018/10/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#ifndef TotalUrls_h
#define TotalUrls_h


#define kIP @"172.22.200.48:8081"


#define kRegisterUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/register", kIP]
#define kLoginUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/login", kIP]
#define kGainBaseMsgUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/basemsg/gain", kIP]
#define kUpdateBaseMsgUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/basemsg/update", kIP]
#define kMainMessageUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/main_message", kIP]


#endif /* TotalUrls_h */
