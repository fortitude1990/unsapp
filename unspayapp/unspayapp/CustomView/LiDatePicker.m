//
//  LiDatePicker.m
//  UNS5
//
//  Created by 李志敬 on 2017/10/17.
//  Copyright © 2017年 MaChenxi. All rights reserved.
//



#import "LiDatePicker.h"

#define kItemHeight kAutoScaleNormal(88)

@interface LiDatePicker ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIView *dismissView;
@property (nonatomic, weak) UIView *backView;

@property (nonatomic, strong)NSMutableArray *yearsArray;
@property (nonatomic, strong)NSMutableArray *monthsArray;

@property (nonatomic, strong)UIPickerView *pickerView;

@property (nonatomic, strong)NSMutableString *totalString;


@end

@implementation LiDatePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)show {
    
    self.lineBackgroundColor = KHexColor(0x69BDFF);
    self.titleColorForSelectedRow =KHexColor(0x69BDFF);
    self.titleColorForOtherRow = [UIColor grayColor];
    
    
    CGFloat height = kAutoScaleNormal(430);
    CGFloat height1 = kAutoScaleNormal(88);
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRectWidth, kRectHeight)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [window addSubview:backView];
    self.backView = backView;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kRectHeight, kRectWidth, height + height1)];
    view.backgroundColor = [UIColor whiteColor];
    [window addSubview:view];
    self.headerView = view;
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = KHexColor(0xb6b6b8);
    [view addSubview:topLine];
    topLine.frame = CGRectMake(0, height1 - 0.5, kRectWidth, 0.5);
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(view.frame), kRectWidth, height);
    self.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
    [window addSubview:self];
    
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, height1)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancel];
//    self.cancelButton = cancel;
    if (_hiddenCancel) {
        cancel.hidden = YES;
    }

    
    
    UIButton *confirm = [[UIButton alloc]initWithFrame:CGRectMake(kRectWidth - 60, 0, 50, height1)];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor: KHexColor(0x69BDFF) forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirmButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirm];
//    self.confirmButton = confirm;
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = _title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [view addSubview:titleLabel];
    titleLabel.frame = CGRectMake(CGRectGetMaxX(cancel.frame), 0, kRectWidth - 60 * 2, height1);
    
    
    UIView *dismissView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kRectWidth, kRectHeight - height - height1)];
    dismissView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelButtonHandler)];
    [dismissView addGestureRecognizer:tap];
    [window addSubview:dismissView];
    self.dismissView = dismissView;
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, height1, kRectWidth, height)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [view addSubview:pickerView];
    self.pickerView = pickerView;
    

    UIView *rowTopLine = [[UIView alloc] init];
    rowTopLine.backgroundColor = KHexColor(0xb6b6b8);
    [pickerView addSubview:rowTopLine];
    rowTopLine.frame = CGRectMake(0, (CGRectGetHeight(pickerView.frame) - kItemHeight)/2.0, kRectWidth, 0.5);
    
    UIView *rowBottomLine = [[UIView alloc] init];
    rowBottomLine.backgroundColor = KHexColor(0xb6b6b8);
    [pickerView addSubview:rowBottomLine];
    rowBottomLine.frame = CGRectMake(0, (CGRectGetHeight(pickerView.frame) - kItemHeight)/2.0 + kItemHeight, kRectWidth, 0.5);
    
    switch (self.type) {
        case PickerTypeDebitValidThru:
        {
            [pickerView selectRow:self.yearsArray.count-1 inComponent:0 animated:NO];
            [pickerView reloadAllComponents];
            [pickerView selectRow:self.monthsArray.count-1 inComponent:1 animated:NO];
            break;
        }
        case PickerTypeCustom:
        {
            [pickerView reloadAllComponents];
            break;
        }
        default:
            break;
    }
    

    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = view.frame;
        frame.origin.y = kRectHeight - frame.size.height;
        view.frame = frame;
    }];
    
}

- (void)cancelButtonHandler{
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.headerView.frame;
        frame.origin.y = kRectHeight;
        self.headerView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backView removeFromSuperview];
        [self.dismissView removeFromSuperview];
        [self.headerView removeFromSuperview];
    }];
    
    
}

- (void)confirmButtonHandler{
    
    
    switch (self.type) {
        case PickerTypeCustom:
        {
            NSMutableArray *rowArray = [NSMutableArray array];
            for (int i = 0; i < self.elementsArray.count; i ++) {
                NSInteger index = [self.pickerView selectedRowInComponent:i];
                [rowArray addObject:@(index)];
            }
            
            
            self.totalString = [NSMutableString string];
            [self.elementsArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger index = [self.pickerView selectedRowInComponent:idx];
                NSString *string = obj[index];
                if (self.totalString.length > 0) {
                    self.totalString = (NSMutableString *) [self.totalString stringByAppendingString:@"/"];
                }
                self.totalString = (NSMutableString *)[self.totalString stringByAppendingString:string];
            }];
            
            [self cancelButtonHandler];
            
            if ([self.delegate respondsToSelector:@selector(datePicker:date:)]) {
                [self.delegate datePicker:self date:self.totalString];
            }
            
            break;
        }
        case PickerTypeDebitValidThru:
        {
            NSString *year = [self.yearsArray objectAtIndex:[self.pickerView selectedRowInComponent:1]];
            NSString *month = [self.monthsArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            
            NSString *dateString = [NSString stringWithFormat:@"%02ld/%02ld", (long)[month integerValue],(long)[year integerValue]];
            
            [self cancelButtonHandler];
            
            if ([self.delegate respondsToSelector:@selector(datePicker:date:)]) {
                [self.delegate datePicker:self date:dateString];
            }
            break;
        }
        default:
            break;
    }
    

    
}

- (NSString *)currentYear{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yy";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
    
}

- (NSString *)currentMonth{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

#pragma GETTER

/*
- (NSMutableArray *)yearsArray{
    
    _yearsArray = [NSMutableArray arrayWithCapacity:0];
    NSString *year = [self currentYear];
    int i = 10;
    while (i > 0) {
        [_yearsArray addObject:year];
        NSInteger yearValue = [year integerValue];
        yearValue--;
        year = [NSString stringWithFormat:@"%ld",yearValue];
        i--;
    }
    
    _yearsArray = (NSMutableArray *)[[_yearsArray reverseObjectEnumerator] allObjects];
    return _yearsArray;
}
 */

- (NSMutableArray *)yearsArray{
    
    _yearsArray = [NSMutableArray arrayWithCapacity:0];
    NSString *year = [self currentYear];
    
    NSInteger yearValue = [year integerValue];
    yearValue += 10;
    year = [NSString stringWithFormat:@"%ld",(long)yearValue];
    
    int i = 20;
    while (i > 0) {
        [_yearsArray addObject:year];
        NSInteger yearValue = [year integerValue];
        yearValue--;
        year = [NSString stringWithFormat:@"%ld",(long)yearValue];
        i--;
    }
    
    _yearsArray = (NSMutableArray *)[[_yearsArray reverseObjectEnumerator] allObjects];
    return _yearsArray;
}

/*
- (NSMutableArray *)monthsArray{
    
    _monthsArray = [NSMutableArray arrayWithCapacity:0];
    
    NSInteger select = [self.pickerView selectedRowInComponent:0];
    NSString *year = self.yearsArray[select];
    NSString *month;
    if ([year isEqualToString:[self currentYear]]) {
        month = [self currentMonth];
    }else{
        month = @"12";
    }
    
    
    while ([month integerValue] > 0) {
        [_monthsArray addObject:month];
        NSInteger monthValue = [month integerValue];
        monthValue --;
        month = [NSString stringWithFormat:@"%ld", (long)monthValue];
    }
    
    _monthsArray = (NSMutableArray *)[[_monthsArray reverseObjectEnumerator] allObjects];
    return _monthsArray;
    
}
*/

- (NSMutableArray *)monthsArray{
    
    _monthsArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *month;
    month = @"12";
    
    while ([month integerValue] > 0) {
        [_monthsArray addObject:month];
        NSInteger monthValue = [month integerValue];
        monthValue --;
        month = [NSString stringWithFormat:@"%ld", (long)monthValue];
    }
    
    _monthsArray = (NSMutableArray *)[[_monthsArray reverseObjectEnumerator] allObjects];
    return _monthsArray;
    
}



#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED{
    return kItemHeight;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    
    switch (self.type) {
        case PickerTypeCustom:
        {
            NSArray *array = self.elementsArray[component];
            return array[row];
            break;
        }
        case PickerTypeDebitValidThru:
        {
            switch (component) {
                case 0:
                    return self.monthsArray[row];
                    break;
                case 1:
                    return self.yearsArray[row];
                    break;
                default:
                    return @"";
                    break;
            }
            break;
        }
        default:
            return @"";
            break;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
//    if (component == 0) {
//        [pickerView reloadComponent:1];
//    }
    
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    switch (self.type) {
        case PickerTypeCustom:
        {
            return self.elementsArray.count;
            break;
        }
        case PickerTypeDebitValidThru:
        {
            return 2;
            break;
        }
        default:
            break;
    }
    
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (self.type) {
        case PickerTypeCustom:
        {
            NSArray *array = self.elementsArray[component];
            return array.count;
            break;
        }
            
        case PickerTypeDebitValidThru:
        {
            switch (component) {
                case 0:
                    return self.monthsArray.count;
                    break;
                case 1:
                    return self.yearsArray.count;
                    break;
                default:
                    return 0;
                    break;
            }
            
            break;
        }
        default:
            break;
    }
    
    return 0;
    

}

@end


