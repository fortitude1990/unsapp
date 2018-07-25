//
//  PayTypeView.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayTypeModel.h"

typedef void(^PayTypeViewHandle)(PayTypeModel *payTypeModel);

@interface PayTypeView : UIView

@property (nonatomic, strong)NSArray *elementsArray;

- (void)show;

- (void)callBack:(PayTypeViewHandle)handle;

@end
