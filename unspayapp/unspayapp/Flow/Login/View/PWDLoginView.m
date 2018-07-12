//
//  PWDLoginView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/11.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PWDLoginView.h"
#import "TimerButton.h"

@interface PWDLoginView()

@property (nonatomic, copy)PWDLoginViewBlock startBlock;
@property (nonatomic, copy)PWDLoginViewBlock endBlock;
@property (nonatomic, copy)PWDLoginViewBlock forgetBlock;
@property (nonatomic, copy)PWDLoginViewBlock gainVerificationStartBlock;
@property (nonatomic, copy)PWDLoginViewBlock gainVerificationEndBlock;

@property (nonatomic, strong)TimerButton *verificationBtn;
@property (nonatomic, strong)UIView *twoLine;
@property (nonatomic, strong)UIView *oneLine;


@end

@implementation PWDLoginView

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
    
    /*
    self.mobileTF = nil;
    self.pwdTF = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    */
    
    UITextField *mobileTF = [[UITextField alloc] init];
    mobileTF.placeholder = @"请输入手机号码";
    mobileTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    mobileTF.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    [self addSubview:mobileTF];
    [mobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kAutoScaleNormal(90)));
        make.right.equalTo(@(kAutoScaleNormal(-90)));
        make.top.equalTo(@(kAutoScaleNormal(10)));
        make.height.equalTo(@(kAutoScaleNormal(80)));
    }];
    
    UIView *oneLine = [[UIView alloc] init];
    oneLine.backgroundColor = KHexColor(0xe9e9e9);
    [self addSubview:oneLine];
    [oneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kAutoScaleNormal(55)));
        make.right.equalTo(@(kAutoScaleNormal(-55)));
        make.top.equalTo(mobileTF.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    
    UITextField *pwdTF = [[UITextField alloc] init];
    pwdTF.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    pwdTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self addSubview:pwdTF];
    
    UIView *twoLine = [[UIView alloc] init];
    twoLine.backgroundColor = KHexColor(0xe9e9e9);
    [self addSubview:twoLine];
    
    TimerButton *verificationBtn;
    
    switch (self.loginType) {
        case LoginTypePwd:
        {
            pwdTF.placeholder = @"密码";
            pwdTF.secureTextEntry = YES;
            [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(kAutoScaleNormal(90)));
                make.right.equalTo(@(kAutoScaleNormal(-90)));
                make.top.equalTo(oneLine.mas_bottom).offset(kAutoScaleNormal(50));
                make.height.equalTo(@(kAutoScaleNormal(66)));
            }];
            

            [twoLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(kAutoScaleNormal(55)));
                make.right.equalTo(@(kAutoScaleNormal(-55)));
                make.top.equalTo(pwdTF.mas_bottom);
                make.height.equalTo(@0.5);
            }];
            
            break;
        }
        case LoginTypeVerification:
        {
            verificationBtn = [TimerButton buttonWithType:UIButtonTypeCustom];
            [verificationBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [verificationBtn setTitleColor:KHexColor(0x0068b7) forState:UIControlStateNormal];
            verificationBtn.titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
            verificationBtn.layer.borderColor = KHexColor(0x0068b7).CGColor;
            verificationBtn.layer.borderWidth = 0.5;
            verificationBtn.layer.cornerRadius = kAutoScaleNormal(33);
            verificationBtn.clipsToBounds = YES;
            [verificationBtn addTarget:self action:@selector(verificationBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:verificationBtn];
            [verificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(kAutoScaleNormal(-55)));
                make.top.equalTo(oneLine.mas_bottom).offset(kAutoScaleNormal(50));
                make.width.equalTo(@(kAutoScaleNormal(250)));
                make.height.equalTo(@(kAutoScaleNormal(66)));
            }];
            
            pwdTF.placeholder = @"输入验证码";
            [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(kAutoScaleNormal(90)));
                make.right.equalTo(verificationBtn.mas_left).offset(kAutoScaleNormal(-30));
                make.top.equalTo(oneLine.mas_bottom).offset(kAutoScaleNormal(50));
                make.height.equalTo(@(kAutoScaleNormal(66)));
            }];
            
            
            [twoLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(kAutoScaleNormal(55)));
            make.right.equalTo(verificationBtn.mas_left).offset(kAutoScaleNormal(-30));
                make.top.equalTo(pwdTF.mas_bottom);
                make.height.equalTo(@0.5);
            }];
            
            
            break;
        }
        default:
            break;
    }
    
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:KHexColor(0x0068b7) forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(24)];
    [forgetBtn addTarget:self action:@selector(forgetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kAutoScaleNormal(90)));
        make.top.equalTo(twoLine.mas_bottom).offset(kAutoScaleNormal(22));
        make.height.equalTo(@(kAutoScaleNormal(33)));
        make.width.equalTo(@(kAutoScaleNormal(130)));
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = KHexColor(0x0068b7);
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(34)];
    loginBtn.layer.cornerRadius = kAutoScaleNormal(44);
    loginBtn.clipsToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoLine.mas_bottom).offset(kAutoScaleNormal(143));
        make.left.equalTo(@(kAutoScaleNormal(55)));
        make.right.equalTo(@(kAutoScaleNormal(-55)));
        make.height.equalTo(@(kAutoScaleNormal(88)));
    }];
    
    self.mobileTF = mobileTF;
    self.pwdTF = pwdTF;
    _verificationBtn = verificationBtn;
    _twoLine = twoLine;
    _oneLine = oneLine;
}

- (void)updateUI{
    
    __weak typeof(self) weakSelf = self;
    
    switch (self.loginType) {
        case LoginTypePwd:
        {
            if (_verificationBtn) {
                [_verificationBtn removeFromSuperview];
            }
            _pwdTF.placeholder = @"密码";
            _pwdTF.secureTextEntry = YES;
            [_pwdTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(kAutoScaleNormal(90)));
                make.right.equalTo(@(kAutoScaleNormal(-90)));
                make.top.equalTo(weakSelf.oneLine.mas_bottom).offset(kAutoScaleNormal(50));
                make.height.equalTo(@(kAutoScaleNormal(66)));
            }];
            
            
            [_twoLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(kAutoScaleNormal(55)));
                make.right.equalTo(@(kAutoScaleNormal(-55)));
                make.top.equalTo(weakSelf.pwdTF.mas_bottom);
                make.height.equalTo(@0.5);
            }];
            
            break;
        }
        case LoginTypeVerification:
        {
            
            self.verificationBtn = [TimerButton buttonWithType:UIButtonTypeCustom];
            [self.verificationBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [self.verificationBtn setTitleColor:KHexColor(0x0068b7) forState:UIControlStateNormal];
            self.verificationBtn.titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
            self.verificationBtn.layer.borderColor = KHexColor(0x0068b7).CGColor;
            self.verificationBtn.layer.borderWidth = 0.5;
            self.verificationBtn.layer.cornerRadius = kAutoScaleNormal(33);
            self.verificationBtn.clipsToBounds = YES;
            [self.verificationBtn addTarget:self action:@selector(verificationBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.verificationBtn];
            [self.verificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(kAutoScaleNormal(-55)));
                make.top.equalTo(weakSelf.oneLine.mas_bottom).offset(kAutoScaleNormal(50));
                make.width.equalTo(@(kAutoScaleNormal(250)));
                make.height.equalTo(@(kAutoScaleNormal(66)));
            }];
            
            
            self.pwdTF.placeholder = @"输入验证码";
            [self.pwdTF mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(kAutoScaleNormal(90)));
                make.right.equalTo(weakSelf.verificationBtn.mas_left).offset(kAutoScaleNormal(-30));
                make.top.equalTo(weakSelf.oneLine.mas_bottom).offset(kAutoScaleNormal(50));
                make.height.equalTo(@(kAutoScaleNormal(66)));
            }];
            
            
            [self.twoLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(kAutoScaleNormal(55)));
                make.right.equalTo(weakSelf.verificationBtn.mas_left).offset(kAutoScaleNormal(-30));
                make.top.equalTo(weakSelf.pwdTF.mas_bottom);
                make.height.equalTo(@0.5);
            }];
            
            break;
        }
        default:
            break;
    }
    
    [self layoutIfNeeded];
    
}



#pragma mark - BtnActions
- (void)forgetBtnAction{
    if (self.forgetBlock) {
        self.forgetBlock(YES, nil);
    }
}

- (void)loginBtnAction{
    
    
}

- (void)verificationBtnAction{
    
    [self.verificationBtn startTimerTotalTime:60 doningTintColor:KHexColor(0x6D6D72) doingBackgroundColor:nil unit:@"s"];
    
}


#pragma mark - Methods

- (void)pwdLoginGainVerificationStart:(PWDLoginViewBlock)gainVerificationStart gainVerificationEnd:(PWDLoginViewBlock)gainVerificationEnd start:(PWDLoginViewBlock)start end:(PWDLoginViewBlock)end forgetPwd:(PWDLoginViewBlock)forget{
    
    if (gainVerificationStart) {
        self.gainVerificationStartBlock = gainVerificationStart;
    }
    
    if (gainVerificationEnd) {
        self.gainVerificationEndBlock = gainVerificationEnd;
    }
    
    if (start) {
        self.startBlock = start;
    }
    
    if (end) {
        self.endBlock = end;
    }
    
    if (forget) {
        self.forgetBlock = forget;
    }
    
}


#pragma mark - Set

- (void)setLoginType:(LoginType)loginType{
    
    if (_loginType != loginType) {
        _loginType = loginType;
        [self updateUI];
    }
    
}


#pragma mark - Networking













@end
