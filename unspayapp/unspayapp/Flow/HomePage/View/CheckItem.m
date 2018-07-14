//
//  CheckItem.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/13.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "CheckItem.h"

#define kMargin 20

@interface CheckItem ()
{
    UILabel *_titleLabel;
}
@property (nonatomic, copy)CommonBlock block;
@end

@implementation CheckItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kMargin));
        make.height.equalTo(@20);
        make.width.equalTo(@150);
        make.centerY.equalTo(self);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@10);
        make.right.equalTo(@(-kMargin));
        make.centerY.equalTo(titleLabel);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = KHexColor(0xe9e9e9);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kMargin));
        make.right.equalTo(@(-kMargin));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction)];
    [self addGestureRecognizer:tap];
    
    _titleLabel = titleLabel;
}

- (void)tapAction:(CommonBlock)action{
    
    if (action) {
        self.block = action;
    }
    
}

- (void)tapGesAction{
    
    if (self.block) {
        self.block(YES,nil);
    }
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = _title;
}

@end
