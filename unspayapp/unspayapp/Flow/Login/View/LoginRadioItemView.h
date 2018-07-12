//
//  LoginRadioItemView.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/10.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoginRadioItemStatus) {
    LoginRadioItemStatusNoneSelect,
    LoginRadioItemStatusSelected
};


@interface LoginRadioItemView : UIView

@property (nonatomic, strong)NSString *title;
@property (nonatomic, assign)LoginRadioItemStatus loginRadioItemStatus;

- (void)tapAction:(void (^)())complete;

@end
