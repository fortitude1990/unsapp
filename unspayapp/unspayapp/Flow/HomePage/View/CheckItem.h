//
//  CheckItem.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/13.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckItem : UIView

@property (nonatomic, strong)NSString *title;

- (void)tapAction:(CommonBlock)action;

@end
