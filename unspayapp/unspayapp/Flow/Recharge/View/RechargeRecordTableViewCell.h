//
//  RechargeRecordTableViewCell.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RecordListType) {
    RecordListTypeRecharge,
    RecordListTypeTotalProperty,
};

@interface RechargeRecordTableViewCell : UITableViewCell

@property (nonatomic, assign)RecordListType recordListType;

@property (strong, nonatomic)  NSString *title;
@property (strong, nonatomic)  NSString *date;
@property (strong, nonatomic)  NSString *amount;
@property (strong, nonatomic)  NSString *status;

@end
