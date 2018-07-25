//
//  PayTypeView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/16.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PayTypeView.h"
#import "PayTypeItem.h"

#define kItemHeight kAutoScaleNormal(100)

@interface PayTypeView()

@property (nonatomic, strong)UIView *topView;

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)NSMutableArray *itemsArray;

@property (nonatomic, copy)PayTypeViewHandle block;

@end


@implementation PayTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)leftBtnAction{
    [self dismiss];
}

- (UIView *)topView{
    if (!_topView) {
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor whiteColor];
        
        _topView = topView;
        
        
    }
    return _topView;
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(self.mas_bottom);
            make.height.equalTo(@((self.elementsArray.count + 1) * kItemHeight));
        }];
        
        [self.backView.superview layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (void)show{
    
    if ([self.subviews containsObject:self.backView]) {
        [self.backView removeFromSuperview];
    }
    
    [self createUI];
}

- (void)createUI{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    self.itemsArray = [NSMutableArray array];
    
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.mas_bottom);
        make.height.equalTo(@((self.elementsArray.count + 2) * kItemHeight));
    }];
    
    [self.backView addSubview:self.topView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(kItemHeight));
    }];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    backBtn.tintColor = [UIColor lightGrayColor];
    [backBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kAutoScaleNormal(40)));
        make.height.width.equalTo(@(kAutoScaleNormal(40)));
        make.centerY.equalTo(self.topView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择付款方式";
    titleLabel.textColor = KHexColor(0x24242d);
    titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(34)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.centerY.centerX.equalTo(self.topView);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = KHexColor(0xd9d9d9);
    [self.topView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.elementsArray];
    
 
    
  
    
    for (int i = 0; i < array.count; i++) {

        PayTypeModel * obj = array[i];

        PayTypeItem *payTypeItem = [[PayTypeItem alloc] init];
        payTypeItem.imageName = obj.imageName;
        payTypeItem.selectImageName = obj.selectImageName;
        payTypeItem.index = i;
        
        if (obj.type == PayTypeModelTypeBalanceShow) {
            
            payTypeItem.userInteractionEnabled = NO;
            payTypeItem.attributeLowLightTitle = obj.title;
            
        }else if (obj.type == PayTypeModelTypeUseBalance) {
            
            payTypeItem.attributeNomarlTitle = obj.title;
            
        }else{
            payTypeItem.title = obj.title;
        }
        
        [self.backView addSubview:payTypeItem];
        [payTypeItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(self.topView.mas_bottom).offset(kItemHeight * i);
            make.height.equalTo(@(kItemHeight));
        }];

        [self.itemsArray addObject:payTypeItem];
        
        [payTypeItem callBack:^(NSInteger index) {
            
            [self dismiss];
            
            PayTypeModel *model = array[i];
            
            switch (model.type) {
                case PayTypeModelTypeDefault:
                {
                    for (int i = 0; i < self.itemsArray.count - 1; i++) {
                        PayTypeItem *item = self.itemsArray[i];
                        if (item.index == index) {
                            item.selected = YES;
                        }else{
                            item.selected = NO;
                        }
                    }
                    break;
                }
                case PayTypeModelTypeUseNewBank:{
                    
                    break;
                }
                default:
                    break;
            }
            

            if (self.block) {
                self.block(model);
            }
            
            
            /*
            if(index == self.itemsArray.count - 1){
                
                [self dismiss];
                
            }else{
                for (int i = 0; i < self.itemsArray.count - 1; i++) {
                    PayTypeItem *item = self.itemsArray[i];
                    if (item.index == index) {
                        item.selected = YES;
                    }else{
                        item.selected = NO;
                    }
                }
            }
            */

            
        }];
        
    }
    
    

    [self layoutIfNeeded];
    
    
        [UIView animateWithDuration:0.2 animations:^{
            
            [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(@0);
                make.bottom.equalTo(@0);
                make.height.equalTo(@((self.elementsArray.count + 1) * kItemHeight));
            }];
            
            [self.backView.superview layoutIfNeeded];
            
        }];
        
    

    
    
}

- (void)callBack:(PayTypeViewHandle)handle{
    if (handle) {
        self.block = handle;
    }
}

@end
