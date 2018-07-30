//
//  AuthItem.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "AuthItem.h"

#define kMargin 20

@interface AuthItem()
{
    UIView *_topLine;
    UIView *_bottomLine;
}
@end


@implementation AuthItem

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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"标题";
    titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kMargin));
        make.width.equalTo(@(kAutoScaleNormal(200)));
        make.height.equalTo(@30);
        make.centerY.equalTo(self);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入姓名";
    textField.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    textField.textAlignment = NSTextAlignmentRight;
    [self addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(5);
        make.right.equalTo(@(-kMargin));
        make.height.equalTo(@30);
        make.centerY.equalTo(self);
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = KHexColor(0xd9d9d9);
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = KHexColor(0xd9d9d9);
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    self.titleLabel = titleLabel;
    self.textField = textField;
    _topLine = topLine;
    _bottomLine = bottomLine;
}

- (void)setHiddenTop:(BOOL)hiddenTop{
    _hiddenTop = hiddenTop;
    if (_hiddenTop) {
        _topLine.hidden = YES;
    }else{
        _topLine.hidden = NO;
    }
}

- (void)setHiddenBottom:(BOOL)hiddenBottom{
    _hiddenBottom = hiddenBottom;
    if (_hiddenBottom) {
        _bottomLine.hidden = YES;
    }else{
        _bottomLine.hidden = NO;
    }
}

@end
