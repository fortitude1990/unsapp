//
//  TabItemModel.h
//  UNS5
//
//  Created by 李志敬 on 2018/7/3.
//  Copyright © 2018年 MaChenxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TabItemModel : NSObject

@property (nonatomic, strong)NSString *title;

@property (nonatomic, strong)NSString *highlightImageName;

@property (nonatomic, strong)NSString *normalImageName;

@property (nonatomic, strong)UIColor *highlightColor;

@property (nonatomic, strong)UIColor *nomalColor;

@end
