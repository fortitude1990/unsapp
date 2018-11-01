//
//  ContactsUtils.m
//  unspayapp
//
//  Created by 李志敬 on 2018/10/31.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "ContactsUtils.h"
#import <Contacts/Contacts.h>



static ReturnBlock returnBlock;


@implementation ContactsUtils


+ (void)requestContacts: (ReturnBlock)callback{
    
    if (callback) {
        returnBlock = callback;
    }
    
    if ([self authorizationStatus]) {
        
    }
    
    
}

+ (BOOL)authorizationStatus{
    
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusNotDetermined:
            {
                CNContactStore *store = [[CNContactStore alloc] init];
                [store requestAccessForEntityType:(CNEntityTypeContacts) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        
                    }else{
                        if (returnBlock) {
                            returnBlock(NO, @"通讯录授权失败",nil);
                        }
                    }
                    
                }];
                break;
            }
            case CNAuthorizationStatusRestricted:
            {
                if (returnBlock) {
                    returnBlock(NO, @"没有权限获取通讯录",nil);
                }
                break;
            }
            case CNAuthorizationStatusDenied:
            {
                if (returnBlock) {
                    returnBlock(NO, @"获取通讯录被拒绝",nil);
                }
                break;
            }
            case CNAuthorizationStatusAuthorized:
            {
                return YES;
                break;
            }
            default:
                break;
        }
    } else {
        // Fallback on earlier versions
    }
    
    
    return NO;
}

+ (void)enumerateContacts{
    
    if (@available(iOS 9.0, *)) {
        
        NSArray *keys = @[CNContactPhoneNumbersKey, CNContactGivenNameKey];
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
        CNContactStore *store = [[CNContactStore alloc] init];
        [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            
            
            
        }];
        
    } else {
        // Fallback on earlier versions
    }
    
}


@end
