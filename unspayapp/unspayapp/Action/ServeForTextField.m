//
//  ServeForVCOfTextfield.m
//  ImageSelect
//
//  Created by uns_apple02 on 15/11/24.
//  Copyright © 2015年 fortitude. All rights reserved.
//

#import "ServeForTextField.h"


@interface ServeForTextField ()


@end

@implementation ServeForTextField

+ (ServeForTextField *)defaultServeForVCOfTextfield{
//    static ServeForVCOfTextfield *serve = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        serve = [[ServeForVCOfTextfield alloc] init];
//    });
    ServeForTextField *serve = [[ServeForTextField alloc] init];
    return serve;
}

- (void)startServeFor:(UIView *)view{
    
    self.view = view;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)currentTextField:(UITextField *)textField{
    
    CGRect react = [textField.superview convertRect:textField.frame toView:self.view];
    
    if (CGRectGetMaxY(react) > self.view.frame.size.height) {
        self.height = self.view.frame.size.height;
    }else{
        self.height = CGRectGetMaxY(react);
    }
    
}


- (void)changeViewFrame{
    float minKeyboardHeight = CGRectGetHeight(self.view.frame) - self.keyboardOfHeight;
    
    if (self.originY) {
        
    }else{
        self.originY = 0;
    }
    
    
    if (self.height - minKeyboardHeight > 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0,self.originY + minKeyboardHeight - self.height, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            }];
        });
        

        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0, self.originY, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            }];
        });


        
    }
    
}

static void extracted(ServeForTextField *object, float minKeyboardHeight) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.2 animations:^{
            
            object.view.frame = CGRectMake(0,object.originY + minKeyboardHeight - object.height  , CGRectGetWidth(object.view.frame), CGRectGetHeight(object.view.frame));
            
        }];
    });
}

- (void)keyboardWillChange: (NSNotification *)notification{
    
    NSDictionary *keyboardDic = [notification userInfo];
    CGRect keyboardRect = [[keyboardDic valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float keyboardHeight = CGRectGetHeight(keyboardRect);
    self.keyboardOfHeight = keyboardHeight;
    float minKeyboardHeight = CGRectGetHeight(self.view.frame) - keyboardHeight;
    if (self.height - minKeyboardHeight > 0) {
        extracted(self, minKeyboardHeight) ;

        

    }
    
}

- (void)keyboardWillHide: (NSNotification *)notification{
    
    self.view.frame = CGRectMake(0, self.originY, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.keyboardOfHeight = 0;
    
}

//删除前后空格
- (NSString *)deleteBlankSpace: (NSString *)string{
    if (string.length > 0) {
        NSMutableString *finalString = (NSMutableString *)[NSString stringWithString:string];
        //去除开头空格
        while (1) {
            if(finalString.length > 1){
                NSString *firstString = [finalString substringToIndex:1];
                if ([firstString isEqualToString:@" "]) {
                    finalString = (NSMutableString *)[finalString substringFromIndex:1];
                }else{
                    break;
                }
            }else{
                finalString = nil;
                break;
            }
        }
        //去除尾部空格
        while (1) {
            NSUInteger i = finalString.length;
            if (i >= 2) {
                NSString *lastString = [finalString substringFromIndex:i - 1];
                if ([lastString isEqualToString:@" "]) {
                    finalString = (NSMutableString *)[finalString substringToIndex:i - 1];
                }else{
                    break;
                }
            }else{
                break;
            }
        }
        return finalString;
    }else{
        return nil;
    }
}

//正则表达式
- (BOOL)validateNumber:(NSString *) textString of: (NSString *)option
{
    NSMutableString *number = nil;
    if ([option isEqualToString:@"rate"]) {
        number= [NSMutableString stringWithString:@"^[1-9]([0-9]+)?([.][0-9]([0-9])?)?$|^[0]([.][0-9]([0-9])?)$"] ;
    }else if([option isEqualToString:@"amount"]){
        number= [NSMutableString stringWithString:@"^[1-9]([0-9]+)?$"] ;
    }else if([option isEqualToString:@"mobile"]){
        number = [NSMutableString stringWithString:@"^1[3|4|5|7|8][0-9]\\d{8}$"];
//        number = [NSMutableString stringWithString:@"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$"];
    }else if([option isEqualToString:@"identity"]){
        number = [NSMutableString stringWithString:@"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$"];
    }else if([option isEqualToString:@"bankCard"]){
        number = [NSMutableString stringWithString:@"^\\d{16}([0-9])?([0-9])?([0-9])?$"];
    }
    else if([option isEqualToString:@"license"]){
        number = [NSMutableString stringWithString:@"^\\d{15}$|^\\d{17}[a-z|A-Z]$"];
    }
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}


//禁止输入空格
- (BOOL)forbidInputBlankOf: (NSRange)range content: (NSString *)string location: (NSNumber *)location  For:(id)sender{
    if (location == nil) {
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character == 32) return YES; // 32 unichar for 空格
        }
    }
    
    if (range.location == [location integerValue]) {
        if (string.length > 0) {
            NSMutableString *firstString = nil;
            if (string.length > 1) {
                firstString = (NSMutableString *)[string substringToIndex:1];
            }else{
                firstString = (NSMutableString *)string;
            }
            if ([firstString isEqualToString:@" "]) {
//                [KUIAction showAlerWithTitle:@"提示" message:@"禁止输入空格" cancelTitle:@"确定" okTitle:nil cancelBack:nil okBack:nil of:sender];
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
        
    }else{
        return NO;
    }
}

- (BOOL)isUnicharFrom: (unichar)from to:(unichar)destination of: (NSString *)string{
    
    NSUInteger lengthOfString = string.length;
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
        unichar character = [string characterAtIndex:loopIndex];
        if (character < from) return NO; // 48 unichar for 0
        if (character > destination) return NO; // 57 unichar for 9
    }
    return YES;
}

- (BOOL)isLengthOf: (UITextField *)textField range: (NSRange)range string: (NSString *)string length: (NSNumber *)length{
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    if (proposedNewLength > [length integerValue]){
       return NO;
    }else{
       return YES;
    }
}

@end
