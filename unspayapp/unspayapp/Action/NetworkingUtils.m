//
//  NetworkingUtils.m
//  unspayapp
//
//  Created by 李志敬 on 2018/10/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "NetworkingUtils.h"
#import "DataBaseUtils.h"
#import <NSObject+YYModel.h>
#import "BankCard.h"

@implementation NetworkingUtils

+ (void)baseMsgNetworking: (CommonBlock) complete{
    
    DefaultMessage *defaulteMessage = DefaultMessage.shareMessage;
    NSDictionary *params = @{@"accountId": defaulteMessage.accountId};
    
    [Networking networkingWithHTTPOfPostTo:kGainBaseMsgUrl params:params backData:^(NSData *data) {
        
        if (data.length == 0) {
            complete(NO, @"网络异常");
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *rspCode = jsonDic[@"rspCode"];
        
        if ([rspCode isEqualToString:@"0000"]) {

            BaseMsg *baseMsg = [BaseMsg modelWithJSON:jsonDic];
            defaulteMessage.baseMsg = baseMsg;
            complete(YES, nil);

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [DataBaseUtils archiverBaseMsg];
            });
            
            
        }else{
            NSString *rspMsg = jsonDic[@"rspMsg"];
            NSLog(@"%@", rspMsg);
            complete(NO, rspMsg);

        }
        
        
        
    }];
}

+ (void)propertyNetworking: (CommonBlock) complete{
    
    DefaultMessage *defaulteMessage = DefaultMessage.shareMessage;
    NSDictionary *params = @{@"accountId": defaulteMessage.accountId};
    
    [Networking networkingWithHTTPOfPostTo:kMainMessageUrl params:params backData:^(NSData *data) {
        
        if (data.length == 0) {
            complete(NO, @"网络异常");
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *rspCode = jsonDic[@"rspCode"];
        
        if ([rspCode isEqualToString:@"0000"]) {
            
            PropertyMsg *propertyMsg = [PropertyMsg modelWithJSON:jsonDic];
            defaulteMessage.propertyMsg = propertyMsg;
            complete(YES, nil);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [DataBaseUtils archiverPropertyMsg];
            });
            
        }else{
            NSString *rspMsg = jsonDic[@"rspMsg"];
            NSLog(@"%@", rspMsg);
            complete(NO, @"网络异常");
        }
        
        
        
    }];
    
    
}

+ (void)bankListNetworking:(ReturnBlock)callback{
    
    if (callback == nil) {
        return;
    }
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    NSDictionary *params = @{@"accountId" : defaultMessage.accountId};
    
    [Networking networkingWithHTTPOfPostTo:kBankListUrl params:params backData:^(NSData *data) {
        
        if (data.length == 0) {
            callback(NO, @"无法连接服务器，请稍后重试", nil);
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *rspCode = jsonDic[@"rspCode"];
        
        if ([rspCode isEqualToString:@"0000"]) {
            
            NSArray *array = jsonDic[@"list"];
            
            if ([array isEqual:[NSNull null]] || array == nil || array.count == 0) {
                callback(YES, @"成功", array);
            }else{
                NSMutableArray *callBackArray = [NSMutableArray array];
                for (NSDictionary *dic in array) {
                
                    BankCard *bankCard = [BankCard modelWithJSON:dic];
                    [callBackArray addObject:bankCard];
                    
                }
                callback(YES, @"成功", callBackArray);
            }
            

        }else{
            NSString *rspMsg = jsonDic[@"rspMsg"];
            NSLog(@"%@", rspMsg);
            callback(NO, rspMsg, nil);
        }
        
        
    }];
    
    
    
}

+ (void)verifyPayPwd:(NSString *)pwd networking:(CommonBlock)complete{
    
    if (complete == nil || pwd == nil) {
        return;
    }
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    NSDictionary *params = @{@"accountId" : defaultMessage.accountId,
                             @"payPwd" : pwd
                             };
    
    [Networking networkingWithHTTPOfPostTo:kVerifyPayPwdUrl params:params backData:^(NSData *data) {
        
        if (data.length == 0) {
            complete(NO, @"无法连接服务器，请稍后重试");
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *rspCode = jsonDic[@"rspCode"];
        
        if ([rspCode isEqualToString:@"0000"]) {
            
            complete(YES, @"密码正确");
    
        }else{
            NSString *rspMsg = jsonDic[@"rspMsg"];
            NSLog(@"%@", rspMsg);
            complete(NO, rspMsg);
        }
        
        
    }];
    
    
    
}


@end
