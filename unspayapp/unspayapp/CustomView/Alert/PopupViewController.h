//
//  PopupViewController.h
//  UNS5
//
//  Created by uns_apple02 on 16/3/18.
//  Copyright © 2016年 fortitude. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PopupViewBack)();

@interface PopupViewController : UIViewController

- (instancetype)initWithTitle: (NSString *)title message: (NSString *)message ok: (NSString *)ok cancel: (NSString *)cancel okAction:(PopupViewBack)okAction cancelAction: (PopupViewBack) cancelAction;

@end
