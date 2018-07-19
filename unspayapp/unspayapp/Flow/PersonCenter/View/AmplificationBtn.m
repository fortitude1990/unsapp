//
//  AmplificationBtn.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/18.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "AmplificationBtn.h"
#import "TriangleView.h"

#define kMargin kAutoScaleNormal(13)

@interface AmplificationBtn()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    TriangleView *_triangleView;
}

@property (nonatomic, copy)VoidBlock block;

@end

@implementation AmplificationBtn

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
    
    UIView *imageBV = [[UIView alloc] init];
    [self addSubview:imageBV];
    [imageBV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.width.height.equalTo(@(kAutoScaleNormal(116)));
        make.centerX.equalTo(self);
    }];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [imageBV addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(kMargin));
        make.bottom.right.equalTo(@(-kMargin));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.userInteractionEnabled = YES;
    titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageBV.mas_bottom).offset(2);
        make.left.right.equalTo(@0);
        make.height.equalTo(@20);
    }];
    
    TriangleView *triangleView = [[TriangleView alloc] init];
    [self addSubview:triangleView];
    [triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@15);
        make.height.equalTo(@10);
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self);
    }];
    
    triangleView.hidden = YES;
    
    _imageView = imageView;
    _titleLabel = titleLabel;
    _triangleView = triangleView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
}

- (void)tapAction{
    
//    self.selected = self.selected ? NO : YES;
    
    if (!self.selected) {
        self.selected = YES;
        if(self.block){
            self.block();
        }
    }
    
}

- (void)btnAction:(VoidBlock)handler{
    
    if (handler) {
        self.block = handler;
    }
    
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    
    _imageView.image = [UIImage imageNamed:imageName];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if (_selected) {
        _triangleView.hidden = NO;
        [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0);
            make.bottom.right.equalTo(@0);
        }];
    }else{
        _triangleView.hidden = YES;
        [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@(kMargin));
            make.bottom.right.equalTo(@(-kMargin));
        }];
    }
}

@end
