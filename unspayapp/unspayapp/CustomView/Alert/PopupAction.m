//
//  PopupAction.m
//  UNS5
//
//  Created by uns_apple02 on 16/3/18.
//  Copyright © 2016年 fortitude. All rights reserved.
//

#import "PopupAction.h"
#import "AppDelegate.h"


@interface PopupAction ()

@property (nonatomic, strong)id alert;

@property (nonatomic, copy)PopupViewBack cancelAction;

@property (nonatomic, copy)PopupViewBack okAction;

@end


@implementation PopupAction


+ (PopupAction *)defaultPopupAction{
    static PopupAction *popupAction;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popupAction = [[PopupAction alloc] init];
    });
    return popupAction;
}

+ (void)showMessage:(NSString *)message location:(ShowLocation)location{
    // 获取window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *showView = [[UIView alloc] init];
    showView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    showView.frame = CGRectMake(1, 1, 1, 1);
    showView.alpha = 1.0f;
    showView.tag = 321;
    showView.layer.cornerRadius = 5.0f;
    showView.layer.masksToBounds = YES;
    
    for (UIView *view in window.subviews) {
        if (view.tag == 321) {
            [showView removeFromSuperview];
        }
    }
    
    [window addSubview:showView];
    
    UILabel *label = [[UILabel alloc] init];
    UIFont *font = [UIFont systemFontOfSize:15];

    label.text = message;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [showView addSubview:label];
    
    CGRect labelRect = [message boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    label.frame = CGRectMake(10, 5, ceil(CGRectGetWidth(labelRect)), CGRectGetHeight(labelRect));
    
    
    CGFloat showViewWidth;
    if (CGRectGetWidth(labelRect)+20 > [UIScreen mainScreen].bounds.size.width) {
        showViewWidth = [UIScreen mainScreen].bounds.size.width - 20;
    }else{
        showViewWidth = CGRectGetWidth(labelRect)+20;
    }
    
    showView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - showViewWidth)/2, [UIScreen mainScreen].bounds.size.height - (CGRectGetHeight(labelRect)+10) - 100, showViewWidth, CGRectGetHeight(labelRect)+10);
    


    
    if (location == ShowLocationMid) {
        
        labelRect = [message boundingRectWithSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2.0 - 30, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
        
        label.frame = CGRectMake(15, 15, ceil(CGRectGetWidth(labelRect)), CGRectGetHeight(labelRect));
        
        showViewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2.0;
        
         showView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - showViewWidth)/2, CGRectGetMidY([UIScreen mainScreen].bounds) - (CGRectGetHeight(labelRect)+10), showViewWidth, CGRectGetHeight(labelRect)+ 30);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            showView.alpha = 0;
        } completion:^(BOOL finished) {
            [showView removeFromSuperview];
        }];
    });
    

    
}

- (void)popupWithTitle:(NSString *)title message:(NSString *)message ok:(NSString *)ok cancel:(NSString *)cancel okAction:(PopupViewBack)okAction cancelAction:(PopupViewBack)cancelAction of:(id)sender{
    
    //开始忽略
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if (!sender) {
        return;
//        sender =  [[((AppDelegate *)[[UIApplication sharedApplication]delegate]).kNaviController viewControllers] lastObject];
    }
    
    if (IOS_VERSION < 6.0) {

        PopupViewController *pop = [[PopupViewController alloc] initWithTitle:title message:message ok:ok cancel:cancel okAction:^{
            if (okAction) {
                okAction();
            }
        } cancelAction:^{
            if (cancelAction) {
                cancelAction();
            }
        }];
    
        pop.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
        pop.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        //结束忽略
//        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [sender presentViewController:pop animated:YES completion:^{
            
        }];
        
        self.alert = pop;
        
    }else if (IOS_VERSION >= 8.0) {
        
        if (sender) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                
                
                
                if (cancel) {
                    
                    UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        if (cancelAction) {
                            cancelAction();
                        }
                    }];
                    [alertController addAction:cancelAction1];
                }
                
                if (ok) {
                    UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        if (okAction) {
                            okAction();
                        }
                    }];
                    [alertController addAction:okAction1];
                }
                
                
                [sender presentViewController:alertController animated:YES completion:nil];
                
                self.alert = alertController;
            
        }
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        self.alert = alertView;
        if (ok) {
            [alertView addButtonWithTitle:ok];
        }
        if (cancel) {
            [alertView addButtonWithTitle:cancel];
        }
        
            if (cancelAction) {
                self.cancelAction = cancelAction;
            }else{
                self.cancelAction = nil;
            }
        
            if (okAction) {
                self.okAction = okAction;
            }else{
                self.okAction = nil;
            }
        
        //结束忽略
//        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [alertView show];
        
        self.alert = alertView;

    }
}

- (void)dismissPopupView{
    if(!self.alert){
        return;
    }
    
    
    
    if (IOS_VERSION >= 8.0) {
        
        [self.alert dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        
        [self.alert dismissWithClickedButtonIndex:0 animated:YES];
        
    }
    
    
}

#pragma mark -------------------- SVProgressHUD -------------------

//+ (void)SVHUDBackgroundColor{
//    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75]];
//}
//
//+ (void)showSVHUD{
//    [self SVHUDBackgroundColor];
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//}
//
//+ (void)dismissSVHUD{
//    [SVProgressHUD dismiss];
//}



#pragma mark -------------------- UIAlertViewDelegate -------------------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    
    
    
    if((self.cancelAction || self.okAction) && !(self.cancelAction && self.okAction)){
        if(self.cancelAction && buttonIndex == 1){
            self.cancelAction();
        }else if (self.okAction && buttonIndex == 0){
            self.okAction();
        }
        
    }else{
        if(buttonIndex == 0 && self.okAction){
            self.okAction();
        }else if (buttonIndex == 1){
            if(self.cancelAction){
                self.cancelAction();
            }
        }
    }
    
    

    
    
}

@end
