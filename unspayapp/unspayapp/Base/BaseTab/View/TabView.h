//
//  TabView.h
//  UNS5
//
//  Created by 李志敬 on 2018/7/3.
//  Copyright © 2018年 MaChenxi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemBlock)(NSInteger index);

@interface TabView : UIView

@property (nonatomic, strong)NSArray *items;

- (void)didSelect:(ItemBlock)callback;

@end
