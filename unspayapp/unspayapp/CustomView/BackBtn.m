//
//  BackBtn.m
//  QuickPay
//
//  Created by 李志敬 on 2016/11/2.
//  Copyright © 2016年 银生宝支付服务有限公司. All rights reserved.
//

#import "BackBtn.h"

@implementation BackBtn

+ (UIBarButtonItem *)createBackButtonWithAction: (SEL)sel target:(id)target{
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (sel) {
        [leftBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    return leftItem;
}

@end
