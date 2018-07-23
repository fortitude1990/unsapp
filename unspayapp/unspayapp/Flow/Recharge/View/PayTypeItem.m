//
//  PayTypeItem.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PayTypeItem.h"

@interface PayTypeItem()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UIImageView *_selectImageView;
    UIView *_bottomLine;
}
@end


@implementation PayTypeItem

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kAutoScaleNormal(40)));
        make.width.height.equalTo(@(kAutoScaleNormal(50)));
        make.centerY.equalTo(self);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    titleLabel.textColor = KHexColor(0x24242d);
    titleLabel.numberOfLines = 0;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(kAutoScaleNormal(30));
        make.height.equalTo(@(kAutoScaleNormal(80)));
        make.centerY.equalTo(self);
    }];
    
    UIImageView *selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蓝色对勾"]];
    selectImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:selectImageView];
    [selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(kAutoScaleNormal(-40)));
        make.width.height.equalTo(@(kAutoScaleNormal(20)));
        make.centerY.equalTo(self);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = KHexColor(0xd9d9d9);
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    
    _imageView = imageView;
    _titleLabel = titleLabel;
    _selectImageView = selectImageView;
    _bottomLine = bottomLine;
    
    _selectImageView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction)];
    [self addGestureRecognizer:tap];
    
    
}

- (void)tapGesAction{
    
    if (self.block) {
        self.block(self.index);
    }
    
    
}

- (void)setSelected:(NSInteger)selected{
    _selected = selected;
    
    if (_selected) {
        _selectImageView.hidden = NO;
    }else{
        _selectImageView.hidden = YES;
    }
    
}

- (void)callBack:(PayTypeItemBlock)callback{
    if (callback) {
        self.block = callback;
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

- (void)setSelectImageName:(NSString *)selectImageName{
    
    if (selectImageName.length > 0) {
        _selectImageName = selectImageName;
        _selectImageView.image = [UIImage imageNamed:selectImageName];
        _selectImageView.hidden = NO;
    }
    

}

- (void)setHiddenBottomLine:(BOOL)hiddenBottomLine{
    _hiddenBottomLine = hiddenBottomLine;
    if (hiddenBottomLine) {
        _bottomLine.hidden = YES;
    }else{
        _bottomLine.hidden = NO;
    }
}

- (void)setAttributeTitle:(NSString *)attributeTitle{
    _attributeTitle = attributeTitle;

    if (_attributeTitle.length > 0) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_attributeTitle];
        
        NSArray *array = [_attributeTitle componentsSeparatedByString:@"\n"];
        
        NSString *firstStr = array.firstObject;
        [string addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kAutoScaleNormal(30)],
                                NSForegroundColorAttributeName : KHexColor(0xd1d1d3)
                                } range:NSMakeRange(0, firstStr.length)];
        if (array.count > 1) {
            NSString *secondStr = array[1];
            
            [string addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kAutoScaleNormal(26)],
                                    NSForegroundColorAttributeName : KHexColor(0xd1d1d3)
                                    } range:[[string string] rangeOfString:secondStr]];
        }
        
        _titleLabel.text = nil;
        _titleLabel.attributedText = string;
        
    }
    

    
}

@end
