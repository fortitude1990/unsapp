//
//  SwithPayTypeTextView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/24.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "SwithPayTypeView.h"

@interface SwithPayTypeView()<UITextViewDelegate>
{
    UITextView *_textView;
}

@property (nonatomic, copy)VoidBlock block;

@end

@implementation SwithPayTypeView

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

- (void)createUI{
    
    UITextView *textView = [[UITextView alloc] init];
    [self addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(@0);
    }];
    
    
    textView.linkTextAttributes = @{
                                                      NSForegroundColorAttributeName: KHexColor(0x0068b7),
                                                      
                                                      NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                                      
                                                      NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    textView.delegate = self;
    textView.editable = NO;
    textView.scrollEnabled = NO;
    
    _textView = textView;
}

- (void)settingPayType:(NSString *)payType{
    
    NSString *string = [NSString stringWithFormat:@"使用%@，更换",payType];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"switch://"
                             range:[[attributedString string] rangeOfString:@"更换"]];
   _textView.attributedText = attributedString;
    _textView.textAlignment = NSTextAlignmentCenter;
    

    
}

- (void)callBack:(VoidBlock)callBack{
    if (callBack) {
        self.block = callBack;
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    if ([[URL scheme] isEqualToString:@"switch"]) {
//        [self switchBank];
        if (self.block) {
            self.block();
        }
    }
    
    return YES;
}

@end
