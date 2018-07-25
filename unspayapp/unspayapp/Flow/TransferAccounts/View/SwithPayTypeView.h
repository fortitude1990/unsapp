//
//  SwithPayTypeTextView.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwithPayTypeView : UIView

- (void)settingPayType:(NSString *)payType;
- (void)callBack: (VoidBlock)callBack;
@end
