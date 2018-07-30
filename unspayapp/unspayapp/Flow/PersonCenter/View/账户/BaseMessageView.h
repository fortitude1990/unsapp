//
//  BaseMessageView.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseMessageView : UIView

@property (nonatomic, strong)UIViewController *controller;


- (void)createSubViews;

@end
