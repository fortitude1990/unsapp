//
//  ProgressHUBAction.m
//  unspayapp
//
//  Created by 李志敬 on 2018/10/26.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "ProgressHUB.h"
#import <SVProgressHUD.h>


@implementation ProgressHUB

+ (void)show{
    [SVProgressHUD show];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+ (void)dismiss{
    [SVProgressHUD dismiss];
}

@end
