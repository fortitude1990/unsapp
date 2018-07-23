//
//  AuthItem.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthItem : UIView

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UITextField *textField;

@property (nonatomic, assign)BOOL hiddenTop;

@property (nonatomic, assign)BOOL hiddenBottom;

@end
