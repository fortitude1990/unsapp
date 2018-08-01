//
//  ImagePickUtil.h
//  UU
//
//  Created by 张 斌 on 13-12-12.
//  Copyright (c) 2013年 王 家振. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImagePickUtil : NSObject

+ (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType onlyImage:(BOOL)onlyImage onlyMovie:(BOOL)onlyMovie target:(id)target;
+ (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType onlyImage:(BOOL)onlyImage onlyMovie:(BOOL)onlyMovie presentedTarget:(id)presentedTarget delegateTarget:(id)delegateTarget;

@end
