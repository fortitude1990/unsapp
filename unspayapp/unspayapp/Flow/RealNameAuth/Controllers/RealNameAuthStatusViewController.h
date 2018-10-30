//
//  RealNameAuthStatusViewController.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, QuitType) {
    QuitTypeDismiss,
    QuitTypePop,
};

@interface RealNameAuthStatusViewController : BaseViewController

@property (nonatomic, assign)QuitType quitType;


@end
