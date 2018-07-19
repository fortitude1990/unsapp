//
//  KeyboardView.m
//  QuickPayment
//
//  Created by 李志敬 on 16/7/7.
//  Copyright © 2016年 李志敬. All rights reserved.
//

#import "KeyboardView.h"




@interface KeyboardView ()
{
    UIButton *oneBtn;
    UIButton *twoBtn;
    UIButton *threeBtn;
    UIButton *fourBtn;
    UIButton *fiveBtn;
    UIButton *sixBtn;
    UIButton *sevenBtn;
    UIButton *eightBtn;
    UIButton *nineBtn;
    UIButton *zeroBtn;
    UIButton *deleteBtn;
}


@end

@implementation KeyboardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUIWith:frame];
    }
    return self;
}

- (void)createUIWith: (CGRect)frame{
    
    self.backgroundColor = [UIColor colorWithRed:209/255. green:213/255. blue:219/255. alpha:1.0];
    
    CGFloat width = frame.size.width / 3.0;
    CGFloat height = frame.size.height / 4.0;
    
    oneBtn = [self createBtnWithTitle:@"1" attach:@"  " image:nil frame:CGRectMake(0, 0, width, height)];
    [self addSubview:oneBtn];
    
    twoBtn = [self createBtnWithTitle:@"2" attach:@"ABC" image:nil frame:CGRectMake(width, 0, width, height)];
    [self addSubview:twoBtn];
    
    threeBtn = [self createBtnWithTitle:@"3" attach:@"DEF" image:nil frame:CGRectMake(width * 2, 0, width, height)];
    [self addSubview:threeBtn];
    
    fourBtn = [self createBtnWithTitle:@"4" attach:@"GHI" image:nil frame:CGRectMake(0, height, width, height)];
    [self addSubview:fourBtn];
    
    fiveBtn = [self createBtnWithTitle:@"5" attach:@"JKL" image:nil frame:CGRectMake(width, height, width, height)];
    [self addSubview:fiveBtn];
    
    sixBtn = [self createBtnWithTitle:@"6" attach:@"MNO" image:nil frame:CGRectMake(width * 2, height, width, height)];
    [self addSubview:sixBtn];
    
    sevenBtn = [self createBtnWithTitle:@"7" attach:@"PQRS" image:nil frame:CGRectMake(width * 0, height * 2, width, height)];
    [self addSubview:sevenBtn];
    
    eightBtn = [self createBtnWithTitle:@"8" attach:@"TUV" image:nil frame:CGRectMake(width * 1, height * 2, width, height)];
    [self addSubview:eightBtn];
    
    nineBtn = [self createBtnWithTitle:@"9" attach:@"WXYZ" image:nil frame:CGRectMake(width * 2, height * 2, width, height)];
    [self addSubview:nineBtn];
    
    zeroBtn = [self createBtnWithTitle:@"0" attach:nil image:nil frame:CGRectMake(width * 1, height * 3, width, height)];
    [self addSubview:zeroBtn];
    
    deleteBtn = [self createBtnWithTitle:nil attach:nil image:@"收款_删除" frame:CGRectMake(width * 2, height * 3, width, height)];
    deleteBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:deleteBtn];
}

- (UIButton *)createBtnWithTitle: (NSString *)title attach: (NSString *)attach image: (NSString *)imageName frame: (CGRect)frame{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
//    [button setTitle:title forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor colorWithRed:209/255. green:213/255. blue:219/255. alpha:1.0].CGColor;
    button.layer.borderWidth = 0.5;
    button.tintColor = [UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1.0];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(heightLightBtnAction:) forControlEvents:UIControlEventTouchDown];

    
    if (imageName) {
//        [button setImage:[MyImage imageWithName:imageName] forState:UIControlStateNormal];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
//        imageView.frame = CGRectMake(0, 0, 30, 30 * 32 / 44.0);
        imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button addSubview:imageView];
        imageView.center = CGPointMake((button.frame.size.width) / 2.0, (button.frame.size.height ) / 2.0);
    }
    
    if (title) {
        
//        [button setBackgroundImage:[MyImage imageWithName:@"bg_background"] forState:UIControlStateHighlighted];

        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, button.frame.size.width, button.frame.size.height - 20 - 10)];
        titleLabel.font = [UIFont systemFontOfSize:21];
        titleLabel.textColor = [UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
//        titleLabel.backgroundColor = [UIColor redColor];
        [button addSubview:titleLabel];
        
        UILabel *attachLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), button.frame.size.width, 10)];
        attachLabel.font = [UIFont systemFontOfSize:8];
        attachLabel.textAlignment = NSTextAlignmentCenter;
        attachLabel.textColor = [UIColor colorWithRed:3/255. green:3/255. blue:3/255. alpha:1.0];
        attachLabel.text = attach;
//        attachLabel.backgroundColor = [UIColor yellowColor];
        [button addSubview:attachLabel];
        

        
        if (attach) {
            titleLabel.frame = CGRectMake(0, 10, button.frame.size.width, button.frame.size.height - 20 - 10);
            attachLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame), button.frame.size.width, 10);
        }else{
            titleLabel.frame = CGRectMake(0, 15, button.frame.size.width, button.frame.size.height - 30);
            [attachLabel removeFromSuperview];

        }
        
    
        

    }
    
    return button;
}

- (void)btnAction: (UIButton *)btn{

    
    if (btn == oneBtn) {
        self.backValue(@"1");
    }
    else if(btn == twoBtn){
        self.backValue(@"2");
    }
    else if(btn == threeBtn){
        self.backValue(@"3");
    }
    else if(btn == fourBtn){
        self.backValue(@"4");
    }
    else if(btn == fiveBtn){
        self.backValue(@"5");
    }
    else if(btn == sixBtn){
        self.backValue(@"6");
    }
    else if(btn == sevenBtn){
        self.backValue(@"7");
    }
    else if(btn == eightBtn){
        self.backValue(@"8");
    }
    else if(btn == nineBtn){
        self.backValue(@"9");
    }
    else if(btn == zeroBtn){
        self.backValue(@"0");
    }
    else if(btn == deleteBtn){
        self.backValue(@"del");
    }
    
    NSLog(@"%lu", (unsigned long)btn.state);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(btn == deleteBtn){
            btn.backgroundColor = [UIColor clearColor];
        }else{
            btn.backgroundColor = [UIColor whiteColor];
        }
    });
}

- (void)heightLightBtnAction: (UIButton *)btn{
    if(btn == deleteBtn){
        btn.backgroundColor = [UIColor clearColor];
    }else{
        [btn setBackgroundColor:[UIColor colorWithRed:209/255. green:213/255. blue:219/255. alpha:1.0]];
    }
    
}

- (void)sendValue:(KeyboardValue)backValue{
    self.backValue = backValue;
}


@end
