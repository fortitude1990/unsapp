//
//  PayTypeItem.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PayTypeItemBlock)(NSInteger index);



@interface PayTypeItem : UIView

@property (nonatomic, strong)NSString *imageName;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *attributeTitle;
@property (nonatomic, strong)NSString *selectImageName;
@property (nonatomic, assign)BOOL hiddenBottomLine;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, assign)NSInteger selected;

@property (nonatomic, copy)PayTypeItemBlock block;

- (void)callBack:(PayTypeItemBlock)callback;

@end
