//
//  NetworkingUtils.m
//  unspayapp
//
//  Created by 李志敬 on 2018/10/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "NetworkingUtils.h"

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
            
        }else{
            NSString *rspMsg = jsonDic[@"rspMsg"];
            NSLog(@"%@", rspMsg);
            complete(NO, @"网络异常");
        }
        
        
        
    }];
    
    
}


@end
