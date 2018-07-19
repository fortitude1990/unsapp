//
//  KeyboardView.h
//  QuickPayment
//
//  Created by 李志敬 on 16/7/7.
//  Copyright © 2016年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KeyboardValue)(NSString *backValue);

@interface KeyboardView : UIView

@property (nonatomic, copy)KeyboardValue backValue;

- (void)sendValue: (KeyboardValue) backValue;

@end
