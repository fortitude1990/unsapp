//
//  ServeForVCOfTextfield.h
//  ImageSelect
//
//  Created by uns_apple02 on 15/11/24.
//  Copyright © 2015年 fortitude. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ServeForTextField : NSObject

@property(nonatomic, strong)UIView *view;

@property (nonatomic, assign)CGFloat height;

@property (nonatomic, assign)CGFloat keyboardOfHeight;

@property (nonatomic, assign)CGFloat originY;


+ (ServeForTextField *)defaultServeForVCOfTextfield;

- (void)startServeFor:(UIView *)view;

- (void)changeViewFrame;

- (void)currentTextField: (UITextField *)textField;


- (NSString *)deleteBlankSpace: (NSString *)string;

- (BOOL)validateNumber:(NSString *) textString of: (NSString *)option;

- (BOOL)forbidInputBlankOf: (NSRange)range content: (NSString *)string location: (NSNumber *)location  For:(id)sender;

- (BOOL)isUnicharFrom: (unichar)from to:(unichar)destination of: (NSString *)string;

- (BOOL)isLengthOf: (UITextField *)textField range: (NSRange)range string: (NSString *)string length: (NSNumber *)length;
@end
