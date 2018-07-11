//
//  TabItemView.h
//  UNS5
//
//  Created by 李志敬 on 2018/7/3.
//  Copyright © 2018年 MaChenxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabItemModel.h"

typedef NS_ENUM(NSInteger, MyState) {
    MyStateNoSelected,
    MyStateSelect
};

typedef void(^MyBlock)(NSInteger index);

@interface TabItemView : UIView


@property (nonatomic, strong)TabItemModel *itemModel;

@property (nonatomic, assign)MyState myState;

@property (nonatomic, assign)NSInteger myTag;


- (void)callBack: (MyBlock)callBack;

@end
