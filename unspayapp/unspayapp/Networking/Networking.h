//
//  Networking.h
//  UNS2
//
//  Created by uns_apple02 on 15/9/23.
//  Copyright (c) 2015年 fortitude. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Networking : NSObject<NSURLConnectionDataDelegate>


@property (nonatomic, copy) void(^backBlock)(NSData *);


+ (void)networkingWithHTTPOfPostTo:(NSString *)urlString andBody:(NSString *)bodyString backData:(void (^)(NSData *))backData;

+ (void)networkingWithHttpOfGetTo: (NSString *)urlString backData: (void(^)(NSData *))backData;

+ (void)networkingWithHTTPOfPostTo:(NSString *)urlString params:(NSDictionary *)parameters backData:(void (^)(NSData *))backData;

@end
