//
//  NextButton.m
//  UNS8
//
//  Created by 李志敬 on 2018/2/7.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "NextButton.h"

@implementation NextButton

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
        [self loadData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}


- (void)loadData{
    
    [self setTitle:@"下一步" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(34)];
    self.backgroundColor = KHexColor(0xdfe1e5);
    self.layer.cornerRadius = kAutoScaleNormal(8);
    [self noResponse];
}

- (void)noResponse{
    self.backgroundColor = KHexColor(0xb6b6b8);
    self.userInteractionEnabled = NO;
}

- (void)canResponse{
    self.backgroundColor = KHexColor(0x0068B7);
    self.userInteractionEnabled = YES;
}


@end
