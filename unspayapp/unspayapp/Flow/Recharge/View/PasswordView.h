//
//  PasswordView.h
//  QuickPayment
//
//  Created by 李志敬 on 16/7/8.
//  Copyright © 2016年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PasswordAuthComplete)(id data);


@interface PasswordView : UIView

@property (nonatomic, strong)NSString *name ;

@property (nonatomic, strong)NSString *amount;

@property (nonatomic, copy)PasswordAuthComplete auth;

- (void)passwordAuthComplete: (PasswordAuthComplete)auth;

- (void)showBackView;
@end
