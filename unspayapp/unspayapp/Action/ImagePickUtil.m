//
//  ImagePickUtil.m
//  UU
//
//  Created by 张 斌 on 13-12-12.
//  Copyright (c) 2013年 王 家振. All rights reserved.
//

#import "ImagePickUtil.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation ImagePickUtil

+ (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType onlyImage:(BOOL)onlyImage onlyMovie:(BOOL)onlyMovie target:(id)target{
    [ImagePickUtil getMediaFromSource:sourceType onlyImage:onlyImage onlyMovie:onlyMovie presentedTarget:target delegateTarget:target];
}

+ (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType onlyImage:(BOOL)onlyImage onlyMovie:(BOOL)onlyMovie presentedTarget:(id)presentedTarget delegateTarget:(id)delegateTarget
{
    NSArray* mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0)
    {
        NSArray* mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = delegateTarget;
        if ((onlyImage == NO)&&(onlyMovie == NO)) {
            picker.mediaTypes = mediaTypes;
        }
        else if ((onlyImage == NO)&&(onlyMovie == YES))
        {
            picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeMovie,nil];
        }
        else if ((onlyImage == YES)&&(onlyMovie == NO))
        {
            picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage,nil];
        }
        else
        {
            NSAssert(NO, @"can not both set to yes");
        }
        
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [presentedTarget presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"设备不支持拍照."
                                                       delegate:self
                                              cancelButtonTitle:@"Drat!"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

@end
