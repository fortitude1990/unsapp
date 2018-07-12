//
//  PopupAction.h
//  UNS5
//
//  Created by uns_apple02 on 16/3/18.
//  Copyright © 2016年 fortitude. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopupViewController.h"

typedef NS_ENUM(NSInteger, ShowLocation) {
    ShowLocationBottom,
    ShowLocationMid
};

@interface PopupAction : NSObject

+ (void)showMessage:(NSString *)message location:(ShowLocation)location;

+ (PopupAction *)defaultPopupAction;

- (void)popupWithTitle: (NSString *)title  message: (NSString *)message ok: (NSString *)ok cancel: (NSString *)cancel okAction:(PopupViewBack)okAction cancelAction: (PopupViewBack) cancelAction of:(id)sender;

//+ (void)showSVHUD;
//
//+ (void)dismissSVHUD;

@end
