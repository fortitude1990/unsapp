//
//  AppCenterCollectionViewCell.m
//  UNS5
//
//  Created by 李志敬 on 2018/7/4.
//  Copyright © 2018年 MaChenxi. All rights reserved.
//

#import "HomePageCollectionViewCell.h"
#import "HomePageItemModel.h"

@interface HomePageCollectionViewCell()

{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UIImageView *_badgeImageView;
}

@end

@implementation HomePageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
   
    
    [self.superview layoutIfNeeded];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(31));
        make.height.equalTo(imageView.mas_width);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-5);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(imageView.mas_bottom).offset(2);
        make.height.equalTo(@15);
    }];

    UIImageView *badgeImageView = [[UIImageView alloc] init];
    badgeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView addSubview:badgeImageView];
    [badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(-5);
        make.bottom.equalTo(imageView.mas_top).offset(5);
        make.width.equalTo(@(kAutoScaleNormal(27.8)));
        make.height.equalTo(@(kAutoScaleNormal(14.9)));
    }];

    _imageView = imageView;
    _titleLabel = titleLabel;
    _badgeImageView = badgeImageView;
    
//    _imageView.backgroundColor = [UIColor orangeColor];
//    _titleLabel.backgroundColor = [UIColor lightGrayColor];
//    _badgeImageView.backgroundColor = [UIColor redColor];
    
    _imageView.userInteractionEnabled = YES;
    _titleLabel.userInteractionEnabled = YES;
    
}

- (void)setDataSource:(HomePageItemModel *)dataSource{
    _dataSource = dataSource;
    
    if (_dataSource.hideen == YES) {
        _imageView.image = [UIImage imageNamed:@"升级中"];
        _titleLabel.text = @"升级中";
        self.userInteractionEnabled = NO;
        _badgeImageView.hidden = YES;
        return;
    }
    
    self.userInteractionEnabled = YES;
    
    if (_dataSource.badgeImageName.length > 0) {
        _badgeImageView.hidden = NO;
        _badgeImageView.image = [UIImage imageNamed:_dataSource.badgeImageName];
    }else{
        _badgeImageView.hidden = YES;
    }
    
    _imageView.image = [UIImage imageNamed:_dataSource.itemImageName];
    _titleLabel.text = _dataSource.title;
    
}

@end
