//
//  PasswordView.m
//  QuickPayment
//
//  Created by 李志敬 on 16/7/8.
//  Copyright © 2016年 李志敬. All rights reserved.
//

#import "PasswordView.h"
#import "KeyboardView.h"
#import "PointView.h"
#import <objc/runtime.h>


#define kMargin 10


@interface PasswordView ()

@property (nonatomic, strong)NSMutableString *password;

@property (nonatomic, strong)NSMutableArray *boxArray;

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UILabel *numLabel;

@end

@implementation PasswordView

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
        [self createUIWithFrame:frame];
    }
    return self;
}



- (void)createUIWithFrame: (CGRect)frame{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 420)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [backBtn setTitle:@"×" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    backBtn.tintColor = [UIColor lightGrayColor];
    if (IOS_VERSION >= 8.0) {
        backBtn.titleLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightLight];
    }else{
        backBtn.titleLabel.font = [UIFont systemFontOfSize:35];
    }
    
    backBtn.frame = CGRectMake(kMargin, kMargin, 30, 30);
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake((frame.size.width - 200) / 2.0, 0, 200, 50);
    titleLabel.text = @"请输入支付密码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50,frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:217/255. green:217/255. blue:217/255. alpha:1.0];
    [self.backView addSubview:line];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame) + kMargin * 1.5, frame.size.width, 20)];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = KHexColor(0xed3735);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.nameLabel];

    
    /*
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame) + kMargin, frame.size.width, 40)];
    self.numLabel.font = [UIFont systemFontOfSize:40];
//    self.nameLabel.textColor = [UIColor colorWithRed:29/255. green:29/255. blue:38/255. alpha:1.0];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.numLabel];
    */
    
    UIView *passwordBoxView = [self createBox];
    CGRect frame1 = passwordBoxView.frame;
    frame1.origin.x = (kRectWidth - frame1.size.width) / 2.0;
    frame1.origin.y = CGRectGetMaxY(self.nameLabel.frame) + kMargin;
    passwordBoxView.frame = frame1;
    [self.backView addSubview:passwordBoxView];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [forgetBtn setTitle:@"忘记支付密码?" forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:forgetBtn];
    forgetBtn.frame = CGRectMake(CGRectGetMaxX(passwordBoxView.frame) - 100, CGRectGetMaxY(passwordBoxView.frame) + kMargin, 100, 21);
    
    
    self.password = [NSMutableString string];
    KeyboardView *keyboard = [[KeyboardView alloc] initWithFrame:CGRectMake(0, self.backView.frame.size.height - 216, self.backView.frame.size.width, 216)];
    [keyboard sendValue:^(NSString *backValue) {
        if ([backValue isEqualToString:@"del"]) {
            
            if (self.password.length > 0) {
                [self clearPassword:backValue];
            }
            
        }else{
            
            if (self.password.length >= 6) {
                return ;
            }else{
                [self showPassword:backValue];
            }
            
            
        }
        NSLog(@"password: %@", self.password);
        
    }];
    [self.backView addSubview:keyboard];
    
    [self showBackView];
}

- (void)forgetBtnAction{
    
}

- (void)showBackView{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [self resume];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.frame = CGRectMake(0, self.frame.size.height - 420, self.frame.size.width, 420);
    }];
    
}

- (void)hiddenView{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 420);
        
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
//        [[KUIAction defaultKUIAction] addIndicatorViewFor:self.superview];
        
        [self removeFromSuperview];
        self.auth(self.password);

//        [self networking];
        
    }];
    
}

- (void)backBtnAction{
    

    
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 420);

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


- (UIView *)createBox{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderColor = [UIColor colorWithRed:159/255. green:159/255. blue:159/255. alpha:1.0].CGColor;
    backView.layer.borderWidth = 1;
    
    self.boxArray = [NSMutableArray arrayWithCapacity:6];
    
    for (int i = 0; i < 6; i++) {
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40 * i, 0, 40, 40)];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.layer.borderColor = [UIColor colorWithRed:159/255. green:159/255. blue:159/255. alpha:1.0].CGColor;
//        label.layer.borderWidth = 0.5;
//        [backView addSubview:label];
//        [self.boxArray addObject:label];
        
        
        PointView *pointView = [[PointView alloc] initWithFrame:CGRectMake(40 * i, 0, 40, 40)];
        
        pointView.alpha = 0;
        [backView addSubview:pointView];
        [self.boxArray addObject:pointView];
        
        if (i > 0 && i < 6) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(40 * i, 0, 1, 40)];
            lineView.backgroundColor = [UIColor colorWithRed:159/255. green:159/255. blue:159/255. alpha:1.0];
            [backView addSubview:lineView];
        }
    }
    
    
    return backView;
}


- (void)showPassword: (NSString *)str{
    
//    UILabel *label = self.boxArray[self.password.length];
//    label.text = @"*";
    
    
    PointView *pointView = self.boxArray[self.password.length];
    pointView.alpha = 1;
    
    self.password = (NSMutableString *)[self.password stringByAppendingString:str];
    
    if (self.password.length == 6) {
        
//        [self backBtnAction];
        
//        [self networking];
        
        
        [self hiddenView];
        
    }
    
}

- (void)clearPassword: (NSString *)str{
    
//    UILabel *label = self.boxArray[self.password.length - 1];
//    label.text = @"";
    
    PointView *pointView = self.boxArray[self.password.length - 1];
    pointView.alpha = 0;
    
    self.password = (NSMutableString *)[self.password substringToIndex:self.password.length - 1];
    
}

- (void)setName:(NSString *)name{
    self.nameLabel.text = name;
}

- (void)setAmount:(NSString *)amount{
//    self.numLabel.text = [NSString stringWithFormat:@"¥%@", amount];
}


- (void)passwordAuthComplete:(PasswordAuthComplete)auth{
    self.auth = auth;
}


- (void)resume{
    
    for (PointView * pointView in self.boxArray) {
        pointView.alpha = 0;
    }
    
    self.password = nil;
    self.password = [NSMutableString string];
    
}

#pragma mark ---------------------------- networking -----------------------------

- (void)networking{
    
   
    
}

#pragma mark ---------------------------- parseData -----------------------------

- (void)parseData: (NSData *)data{
    
    NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", dataString);
    
    
}

@end
