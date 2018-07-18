//
//  LiDatePicker.h
//  UNS5
//
//  Created by 李志敬 on 2017/10/17.
//  Copyright © 2017年 MaChenxi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PickerType){
    PickerTypeDebitValidThru,
    PickerTypeCustom,
};


@protocol LiDatePickerDelegate;

@interface LiDatePicker : UIView

@property (nonatomic, strong)UIColor *titleColorForSelectedRow;
@property (nonatomic, strong)UIColor *titleColorForOtherRow;
@property(nonatomic, strong) UIColor *lineBackgroundColor;  
@property (nonatomic, weak)id<LiDatePickerDelegate>delegate;
@property (nonatomic, strong)NSArray *elementsArray;
@property (nonatomic, assign)PickerType type;
@property (nonatomic, strong)NSString * title;
@property (nonatomic, assign)BOOL hiddenCancel;

- (void)show;

@end


@protocol LiDatePickerDelegate <NSObject>

- (void)datePicker:(LiDatePicker *)datePicker date:(NSString *)dateString;

@end
