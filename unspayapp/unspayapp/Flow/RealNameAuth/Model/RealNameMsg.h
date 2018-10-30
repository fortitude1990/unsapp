//
//  RealNameMsg.h
//  unspayapp
//
//  Created by 李志敬 on 2018/10/26.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RealNameMsg : NSObject

@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *identityId;
@property (nonatomic, strong) NSString *frontFaceOfIdCardPhoto;
@property (nonatomic, strong) NSString *reverseSideOfIdCardPhoto;
@property (nonatomic, strong) NSString *identityIdValidDate;


@end

NS_ASSUME_NONNULL_END
