//
//  PayTypeModel.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/17.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PayTypeModelType) {
    PayTypeModelTypeDefault,
    PayTypeModelTypeUseNewBank,
    PayTypeModelTypeBalanceShow,
};

@interface PayTypeModel : NSObject

@property (nonatomic, strong)NSString *imageName;

@property (nonatomic, strong)NSString *title;

@property (nonatomic, strong)NSString *selectImageName;

@property (nonatomic, assign)PayTypeModelType type;

@end
