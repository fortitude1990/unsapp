//
//  RecordDetailViewController.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, RecordType) {
    RecordTypeRecharge,
    RecordTypeTransferAccount,
};

@class Deal;
@interface RecordDetailViewController : BaseViewController

@property (nonatomic, assign)RecordType recordType;

@property (nonatomic, strong) Deal *deal;

@end
