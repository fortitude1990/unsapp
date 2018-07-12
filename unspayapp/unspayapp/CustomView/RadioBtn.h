//
//  RadioBtn.h
//  UNS8
//
//  Created by 李志敬 on 2018/2/6.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SelectedState) {
    SelectedStateSelect,
    SelectedStateNoSelect,
};

//typedef void(^RadioBtnBlock)(SelectedState selectedState);

@interface RadioBtn : UIButton

- (void)setNormalState:(SelectedState)selectedState;

- (SelectedState)gainSelectState;

@end
