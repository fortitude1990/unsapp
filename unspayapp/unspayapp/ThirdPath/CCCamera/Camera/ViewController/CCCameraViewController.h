//
//  CCCameraViewController.h
//  CCCamera
//
//  Created by wsk on 16/8/22.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "CCBaseViewController.h"

typedef void(^CCCameraBlock)(UIImage *image,CGRect frame);

@interface CCCameraViewController : CCBaseViewController

@property (nonatomic, copy)CCCameraBlock block;

- (void)callBack: (CCCameraBlock)cccameraBlock;

@end
