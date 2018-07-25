//
//  SwithPayTypeTextView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "SwithPayTypeView.h"

@interface SwithPayTypeView()
@end

@implementation SwithPayTypeView

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
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UITextView *textView = [[UITextView alloc] init];
    
    
}

@end
