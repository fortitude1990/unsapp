//
//  TabView.m
//  UNS5
//
//  Created by 李志敬 on 2018/7/3.
//  Copyright © 2018年 MaChenxi. All rights reserved.
//

#import "TabView.h"
#import "TabItemView.h"

@interface TabView()

@property (nonatomic, copy)ItemBlock  itemBlock;

@property (nonatomic, strong)NSMutableArray *itemViews;

@end

@implementation TabView

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
        
    }
    return self;
}

- (void)didSelect:(ItemBlock)callback{
    if (callback) {
        self.itemBlock = callback;
    }
    
}

- (void)setItems:(NSMutableArray *)items{
    _items = items;
    [self createSubViews];
}


- (void)createSubViews{
    
    
    if (!self.items || self.items.count == 0) {
        return;
    }
    
    self.layer.shadowColor = KHexColor(0xC8C7CC).CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -0.01);
    self.layer.shadowOpacity = 0.8;
    
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat itemWidth = width / self.items.count;
    
    self.itemViews = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    
    [self.items enumerateObjectsUsingBlock:^(TabItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TabItemView *itemView = [[TabItemView alloc] initWithFrame:CGRectMake(itemWidth * idx, 0, itemWidth, height)];
        itemView.myTag = idx;
        itemView.itemModel = weakSelf.items[idx];
        [self addSubview:itemView];
        if (idx == 0) {
            itemView.myState = MyStateSelect;
        }
        
        if (idx < self.items.count - 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(itemView.frame) - 0.25, 0, 0.5, height)];
            line.backgroundColor = KHexColor(0xC8C7CC);
            [self addSubview:line];
        }
        
        
        [weakSelf.itemViews addObject:itemView];
        
        [itemView callBack:^(NSInteger index) {
            
            if (weakSelf.itemBlock) {
                
                weakSelf.itemBlock(index);
                
                [weakSelf.itemViews enumerateObjectsUsingBlock:^(TabItemView *view, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (view.myTag != index) {
                        view.myState = MyStateNoSelected;
                    }
                    
                }];
                
            }
            
        }];
        
    }];
    
    
    
}


@end
