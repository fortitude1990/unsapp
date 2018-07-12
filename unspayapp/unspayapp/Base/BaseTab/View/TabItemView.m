//
//  TabItemView.m
//  UNS5
//
//  Created by 李志敬 on 2018/7/3.
//  Copyright © 2018年 MaChenxi. All rights reserved.
//

#import "TabItemView.h"

#define NomarlColor KHexColor(0x5f5f5f)
#define HighlightColor KHexColor(0x0068b7)


@interface TabItemView()

@property (nonatomic, strong)UIImageView *myImageView;

@property (nonatomic, strong)UILabel *myTitleLabel;

@property (nonatomic, copy)MyBlock myBlock;

@end

@implementation TabItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSuViews];
    }
    return self;
}


- (void)createSuViews{
    
    
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 24, 24);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    imageView.center = CGPointMake(width / 2.5, height / 2.0);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 5, (CGRectGetHeight(self.frame) - 20)/2.0 , width / 2.0, 20);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:titleLabel];
    
    self.myImageView = imageView;
    self.myTitleLabel = titleLabel;
    
    self.myImageView.userInteractionEnabled = YES;
    self.myTitleLabel.userInteractionEnabled = YES;
    
//    UIView *coverView = [[UIView alloc] init];
//    [self addSubview:coverView];
//    coverView.frame = self.bounds;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapGesture];
    
    if (self.itemModel && self.myState == MyStateNoSelected) {
        self.myImageView.image = [UIImage imageNamed:self.itemModel.normalImageName];
        self.myTitleLabel.text = [NSString stringWithFormat:@"%@", self.itemModel.title];
        self.myTitleLabel.textColor = NomarlColor;

    }
    
    
}

- (void)setItemModel:(TabItemModel *)itemModel{
    _itemModel = itemModel;
    
    if (self.myImageView) {
        self.myImageView.image = [UIImage imageNamed:self.itemModel.normalImageName];
    }
    
    if (self.myTitleLabel) {
        self.myTitleLabel.text = [NSString stringWithFormat:@"%@", self.itemModel.title];
        self.myTitleLabel.textColor = NomarlColor;
    }
    
    
}


- (void)callBack:(MyBlock)callBack{
    if (callBack) {
        self.myBlock = callBack;
    }
}

- (void)tapAction{
    
    if (self.myState == MyStateNoSelected) {
        self.myState = self.myState == MyStateNoSelected ? MyStateSelect : MyStateNoSelected;
        
        if (self.myBlock) {
            self.myBlock(self.myTag);
        }
    }
    
}

- (void)setMyState:(MyState)myState{
    _myState = myState;
    
    if (_myState == MyStateNoSelected) {
        
        if (self.myImageView && self.itemModel) {
            self.myImageView.image = [UIImage imageNamed:self.itemModel.normalImageName];
        }
        
        if(self.myTitleLabel){
            self.myTitleLabel.textColor = NomarlColor;
        }
        
        
    }else{
        if (self.myImageView && self.itemModel) {
            self.myImageView.image = [UIImage imageNamed:self.itemModel.highlightImageName];
        }
        
        if(self.myTitleLabel){
            self.myTitleLabel.textColor = HighlightColor;
        }
        
    }
    
}

@end
