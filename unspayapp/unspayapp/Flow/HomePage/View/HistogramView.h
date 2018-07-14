//
//  HistogramView.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/13.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistogramView : UIView

@property (strong, nonatomic) NSString *amount;

@property (strong, nonatomic) NSString *title;

@property (assign, nonatomic) CGFloat percentage;

@property (strong, nonatomic) UIColor *percentageColor;

@end
