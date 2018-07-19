//
//  PointView.m
//  QuickPayment
//
//  Created by 李志敬 on 16/7/8.
//  Copyright © 2016年 李志敬. All rights reserved.
//

#import "PointView.h"

#define kWidth 10

@implementation PointView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGRect frame = CGRectMake((self.frame.size.width - kWidth)/ 2.0, (self.frame.size.height - kWidth)/ 2.0, kWidth, kWidth);
    /*画填充圆
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);
    
    CGContextAddEllipseInRect(context, frame);
    [[UIColor blackColor] set];
    CGContextFillPath(context);
    
}

@end
