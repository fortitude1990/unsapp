//
//  TimerButton.h
//  helloworkd
//
//  Created by 李志敬 on 2017/3/10.
//  Copyright © 2017年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerButton : UIButton

- (void)startTimerTotalTime: (NSInteger)totalTime doningTintColor:(UIColor *)doningTintColor doingBackgroundColor: (UIColor *)doingBackgroundColor unit: (NSString *)unit;

@end
