//
//  DataBaseUtils.m
//  unspayapp
//
//  Created by 李志敬 on 2018/10/25.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "DataBaseUtils.h"

static NSString *baseMsgPath = @"baseMsg.plist";
static NSString *baseMsgKey = @"baseMsg";
static NSString *propertyMsgPath = @"propertyMsg.plist";
static NSString *propertyMsgKey = @"propertyMsg";


@implementation DataBaseUtils



+ (BOOL)archiverBaseMsg{
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    if (defaultMessage.baseMsg == nil) {
        return NO;
    }
    
    return [self archiverInPath:baseMsgPath key:baseMsgKey object:defaultMessage.baseMsg];
}

+ (BaseMsg *)unArchiverBaseMsg{
    return [self unArchiverInPath:baseMsgPath key:baseMsgKey];
}

+ (BOOL)archiverPropertyMsg{
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    if (defaultMessage.propertyMsg == nil) {
        return NO;
    }
    
    return [self archiverInPath:propertyMsgPath key:propertyMsgKey object:defaultMessage.propertyMsg];
}

+ (PropertyMsg *)unArchiverPropertyMsg{
    return [self unArchiverInPath:propertyMsgPath key:propertyMsgKey];
}

+ (BOOL)archiverInPath:(NSString *)path key:(NSString *)key object:(id)object{
    
    
    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [homePath stringByAppendingPathComponent:path];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    BOOL result = [data writeToFile:filePath atomically:NO];
//    BOOL result = [NSKeyedArchiver archiveRootObject:data toFile:filePath];
    
//    NSArray *array = @[@"1"];
//    BOOL result = [array writeToFile:filePath atomically:YES];
    return result;
    
}

+ (id)unArchiverInPath:(NSString *)path key:(NSString *)key{
    
    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [homePath stringByAppendingPathComponent:path];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id baseMsg = [unArchiver decodeObjectForKey:key];
    [unArchiver finishDecoding];
    return baseMsg;
    
}

@end
