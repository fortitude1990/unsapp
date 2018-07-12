//
//  BackBtn.h
//  QuickPay
//
//  Created by 李志敬 on 2016/11/2.
//  Copyright © 2016年 银生宝支付服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackBtn : NSObject

+ (UIBarButtonItem *)createBackButtonWithAction: (SEL)sel target:(id)target;

@end
