//
//  AmplificationBtn.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/18.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmplificationBtn : UIView

@property (nonatomic, strong)NSString *imageName;

@property (nonatomic, strong)NSString *title;

@property (nonatomic, assign)BOOL selected;

- (void)btnAction: (VoidBlock)handler;

@end
