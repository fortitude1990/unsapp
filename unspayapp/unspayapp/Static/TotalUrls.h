//
//  TotalUrls.h
//  unspayapp
//
//  Created by 李志敬 on 2018/10/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#ifndef TotalUrls_h
#define TotalUrls_h


#define kIP @"172.22.200.51:8081"

#define kRegisterUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/register", kIP]
#define kLoginUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/login", kIP]
#define kGainBaseMsgUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/basemsg/gain", kIP]
#define kUpdateBaseMsgUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/basemsg/update", kIP]
#define kMainMessageUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/main_message", kIP]
#define kRealNameUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/realname", kIP]
#define kSetPayPwdUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/setting/pay/passoword", kIP]
#define kBankListUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/banklist", kIP] //获取绑定的银行卡
#define kCardInfoQueryUrl @"http://bmp.unspay.com/web_cardbin/cardbin/get.uns?cardNo=" //卡bin查询
#define kAddBankCardUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/addbankcard", kIP] //添加银行卡
#define kVerifyPayPwdUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/verify/paypwd", kIP] //校验支付密码是否正确
#define kRechargeUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/recharge", kIP] //充值
#define kWithdrawUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/withdraw", kIP] //提现
#define kVerifyTelUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/basemsg/verifyTel", kIP] //校验手机号码是否注册
#define kTransferUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/transfer", kIP] //转账
#define kQueryDealUrl [NSString stringWithFormat:@"http://%@/unsapp_personal/query/deal", kIP] //交易查询

#endif /* TotalUrls_h */
