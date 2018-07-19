//
//  MSCNavigatorView.m
//  helloworkd
//
//  Created by 李志敬 on 2017/8/2.
//  Copyright © 2017年 李志敬. All rights reserved.
//

#import "MSCNavigatorView.h"


@interface MSCNavigatorView ()
{
    CGFloat btnWidth;
}
@property (nonatomic, strong)NSMutableArray *btnArray;

@property (nonatomic, strong)NSMutableArray *badgeLabelArray;

@property (nonatomic, strong)UIView *bottomLineView;

@end

@implementation MSCNavigatorView

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
//        [self createUI];
    }
    return self;
}


- (void)createUI{
    
    [self.superview layoutIfNeeded];
    
    self.backgroundColor = [UIColor whiteColor];
    
    if (self.btnTitleArray.count == 0) {
        return;
    }
    
    CGFloat screenWidth = CGRectGetWidth(self.frame);
    
    btnWidth = screenWidth / self.btnTitleArray.count;
    
    self.badgeLabelArray = [NSMutableArray arrayWithCapacity:0];
    self.btnArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0 ; i < self.btnTitleArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.btnTitleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor colorWithRed:74/255. green:74/255. blue:74/255. alpha:1.0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(btnWidth * i));
            make.top.equalTo(@0);
            make.width.equalTo(@(btnWidth));
            make.bottom.equalTo(@0);
        }];
        
        UILabel *badgeLabel = [[UILabel alloc] init];
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.backgroundColor = [UIColor redColor];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.layer.cornerRadius = 6;
        badgeLabel.font = [UIFont systemFontOfSize:11];
        badgeLabel.text = @"0";
        badgeLabel.adjustsFontSizeToFitWidth = YES;
        badgeLabel.clipsToBounds = YES;
        [btn addSubview:badgeLabel];
        [badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
//            make.right.equalTo(@-10);
            make.width.equalTo(@12);
            make.height.equalTo(@12);
            make.centerX.equalTo(btn).offset(38);
        }];
        
        [self.btnArray addObject:btn];
        [self.badgeLabelArray addObject:badgeLabel];
        
    }
    
    
    
    
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = [UIColor colorWithRed:0 green:131/255. blue:210/255. alpha:1.0];
    [self addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@-0.5);
        make.width.equalTo(@(btnWidth));
        make.height.equalTo(@2);
    }];
    

    
    
}



- (void)setBtnTitleArray:(NSArray *)btnTitleArray{
    _btnTitleArray = btnTitleArray;
    [self createUI];
}

- (void)btnAction: (UIButton *)aBtn{
    
    NSInteger index = [self.btnArray indexOfObject:aBtn];
    [self moveBottomLine:index];
    
    if (self.block) {
        self.block(index);
    }

    
}

- (void)moveBottomLine:(NSInteger)index{
    

    
    [UIView animateWithDuration:0.2 animations:^{
        

        [self.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(btnWidth * index));
        }];
        [self.bottomLineView.superview layoutIfNeeded];

        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self changeBtnState: index];
        }
        
    }];
}

- (void)setToIndex:(NSInteger)toIndex{
    _toIndex = toIndex;
    
    if (self.btnArray.count == 0) {
        return;
    }
    
    UIButton *btn = [self.btnArray objectAtIndex:toIndex];
    [self btnAction:btn];
}

- (void)changeBtnState: (NSInteger)index{
    
    UIColor *defaultColor = [UIColor colorWithRed:74/255. green:74/255. blue:74/255. alpha:1.0];
    UIColor *selectColor = [UIColor colorWithRed:0 green:92/255. blue:162/255. alpha:1.0];
    
    for (UIButton *btn in self.btnArray) {
        
        if ([btn isEqual:self.btnArray[index]]) {
            [btn setTitleColor:selectColor forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:defaultColor forState:UIControlStateNormal];

        }
        
    }
    
}

- (void)setBadgeArray:(NSArray *)badgeArray{
    
    _badgeArray = badgeArray;
    
    for (int i = 0; i < badgeArray.count; i++) {
        
        if (i > self.badgeLabelArray.count) {
            break;
        }
        
        UILabel *label = self.badgeLabelArray[i];
        NSString *badge = badgeArray[i];
        if ([badge integerValue] == 0) {
            label.hidden = YES;
        }else{
            label.hidden = NO;
            label.text = badge;
        }
        
    }
    
}

- (void)setDefaultIndex:(NSInteger)defaultIndex{
    
    _defaultIndex = defaultIndex;
    
    if (defaultIndex > self.btnArray.count) {
        return;
    }
    
    [self.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(btnWidth * defaultIndex));
    }];
    
    [self changeBtnState:defaultIndex];
    
}

- (void)returnBlock:(MSCNavigatorViewBlock)aBlock{
    self.block =  aBlock;
}

@end
