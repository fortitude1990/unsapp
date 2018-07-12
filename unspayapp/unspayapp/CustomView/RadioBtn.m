//
//  RadioBtn.m
//  UNS8
//
//  Created by 李志敬 on 2018/2/6.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RadioBtn.h"


@interface RadioBtn()

@property (nonatomic, assign)SelectedState selectedState;

@end

@implementation RadioBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setSelected];
        [self addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSelected];
        [self addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return self;
}

- (void)setSelected{
    self.selectedState = SelectedStateSelect;
//    [self setImage:[MyImage imageName:@"同意"] forState:(UIControlStateNormal)];
    [self setBackgroundImage:[UIImage imageNamed:@"协议已勾选"] forState:(UIControlStateNormal)];

}

- (void)setNoSelected{
    self.selectedState = SelectedStateNoSelect;
//    [self setImage:[MyImage imageName:@"默认状态"] forState:(UIControlStateNormal)];
    [self setBackgroundImage:[UIImage imageNamed:@"协议未勾选"] forState:(UIControlStateNormal)];

}

- (void)setNormalState:(SelectedState)selectedState{
    switch (selectedState) {
        case SelectedStateNoSelect:
            [self setNoSelected];
            break;
        case SelectedStateSelect:
            [self setSelected];
            break;
        default:
            break;
    }
}

- (void)btnAction{
    
    if (self.selectedState == SelectedStateNoSelect) {
        [self setSelected];
    }else{
        [self setNoSelected];
    }
    
}

- (SelectedState)gainSelectState{
    return self.selectedState;
}

@end
