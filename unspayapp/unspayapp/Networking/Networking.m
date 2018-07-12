//
//  Networking.m
//  UNS2
//
//  Created by uns_apple02 on 15/9/23.
//  Copyright (c) 2015年 fortitude. All rights reserved.
//

#import "Networking.h"

@implementation Networking










+ (void)networkingWithHTTPOfPostTo:(NSString *)urlString andBody:(NSString *)bodyString backData:(void (^)(NSData *))backData{
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            backData(data);
        });
        
    }]resume];
    
}

+ (void)networkingWithHttpOfGetTo: (NSString *)urlString backData: (void(^)(NSData *))backData{
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:45];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            backData(data);
        });
    }]resume];
    
}

+ (void)networkingWithHTTPOfPostTo:(NSString *)urlString params:(NSDictionary *)parameters backData:(void (^)(NSData *))backData{
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error: &error];
    request.HTTPBody  = jsonData;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            backData(data);
        });
        
    }]resume];
}

@end
