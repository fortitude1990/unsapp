//
//  PersonCenterViewController.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/12.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BaseViewController.h"

//typedef void(^ScrollOffsetBlock)(CGPoint offset);

@interface PersonCenterViewController : BaseViewController

@property (nonatomic, copy)CommonBlock myBlock;

- (void)subviewsCanScroll:(CommonBlock) bock;

@end
