//
//  TimerButton.m
//  helloworkd
//
//  Created by 李志敬 on 2017/3/10.
//  Copyright © 2017年 李志敬. All rights reserved.
//

#import "TimerButton.h"

@interface TimerButton ()

{
    UIColor *startTintColor;
    UIColor *startBackgroundColor;
    NSString *startTitle;
    NSTimer *timer;
    NSInteger time;
    NSString *aUnit;
}

@end


@implementation TimerButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)startTimerTotalTime: (NSInteger)totalTime doningTintColor:(UIColor *)doningTintColor doingBackgroundColor: (UIColor *)doingBackgroundColor unit: (NSString *)unit{
    
    self.userInteractionEnabled = NO;
    
    startTintColor = self.tintColor;
    startBackgroundColor = [UIColor colorWithCGColor:self.layer.borderColor];
    startTitle = [self titleForState:UIControlStateNormal];
    time = totalTime;
    aUnit = unit;
    
    if (doingBackgroundColor) {
        self.backgroundColor = doingBackgroundColor;
    }
    
    if (doningTintColor) {
        [self setTitleColor:doningTintColor forState:UIControlStateNormal];
        self.layer.borderColor = doningTintColor.CGColor;
    }
    
    [self setTitle];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}


- (void)timerAction: (NSTimer *)aTimer{
    
    time--;
    
    [self setTitle];
    if (time == 0) {
        [self endTiming];
    }
    
    
}

- (void)setTitle{
    NSString *aTitle = [NSString stringWithFormat:@"重新发送(%ld%@)", (long)time, aUnit];
    [self setTitle:aTitle forState:UIControlStateNormal];
}

- (void)endTiming{
    
    self.userInteractionEnabled = YES;
    
    if (startTintColor) {
        self.layer.borderColor = startTintColor.CGColor;
    }
    
    if (startTintColor) {
        [self setTitleColor:startTintColor forState:UIControlStateNormal];
    }
    
    if (startTitle) {
        [self setTitle:startTitle forState:UIControlStateNormal];
    }
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }

}

- (void)dealloc{
    [timer invalidate];
    timer = nil;
}


@end
