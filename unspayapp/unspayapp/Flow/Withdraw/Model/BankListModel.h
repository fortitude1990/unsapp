//
//  BankListModel.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankListModel : NSObject

@property (nonatomic, strong)NSString *bankName;

@property (nonatomic, strong)NSString *bankCardNo;

@property (nonatomic, strong)NSString *bankImageName;

@property (nonatomic, strong)NSString *bankType;

@property (nonatomic, assign)BOOL isSelected;

@property (nonatomic, strong) id params;

@end
