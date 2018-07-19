//
//  MSCNavigatorView.h
//  helloworkd
//
//  Created by 李志敬 on 2017/8/2.
//  Copyright © 2017年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^MSCNavigatorViewBlock)(NSInteger index);

@interface MSCNavigatorView : UIView


@property (nonatomic, strong)NSArray *btnTitleArray;

@property (nonatomic, assign)NSInteger toIndex;

@property (nonatomic, assign)NSInteger defaultIndex;

@property (nonatomic, strong)NSArray *badgeArray;

@property (nonatomic, copy)MSCNavigatorViewBlock block;

- (void)returnBlock: (MSCNavigatorViewBlock)aBlock;

@end
