//
//  GradientView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/25.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI{
    
//    self.clipsToBounds = YES;
    
    /*
    1、colors 渐变的颜色
    2、locations 渐变颜色的分割点
    3、startPoint&endPoint 颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
    */
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)KHexColor(0xe9e9e9).CGColor,(__bridge id)[UIColor whiteColor].CGColor];
        gradientLayer.locations = @[@0,@0.5];
        gradientLayer.startPoint = CGPointMake(0, 0);
        if (self.frame.size.width > self.frame.size.height) {
            gradientLayer.endPoint = CGPointMake(1, 0);
        }else{
            gradientLayer.endPoint = CGPointMake(0, 1);
        }
        gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.layer addSublayer:gradientLayer];

    });
    

    

    
    
}

@end
