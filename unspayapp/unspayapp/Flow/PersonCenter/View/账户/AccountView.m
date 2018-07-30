//
//  AccoutView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "AccountView.h"
#import "MSCNavigatorView.h"
#import "BaseMessageView.h"
#import "SecuritySettingsView.h"
#import "PaySettingsView.h"
#import "RealNameAuthViewController.h"

@interface AccountView()<UIScrollViewDelegate>
{
    SecuritySettingsView *_securitySettingView;
    BaseMessageView *_baseMessageView;
    PaySettingsView *_paySettingView;
}

@property (nonatomic, strong)MSCNavigatorView *twoNavigator;
@property (nonatomic, strong)UIScrollView *scrollView;


@end

@implementation AccountView

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
    
    UIButton *oneNavigator = [UIButton buttonWithType:UIButtonTypeSystem];
    [oneNavigator setTitle:@"实名认证" forState:UIControlStateNormal];
    [oneNavigator setTitleColor:[UIColor colorWithRed:74/255. green:74/255. blue:74/255. alpha:1.0] forState:UIControlStateNormal];
    oneNavigator.titleLabel.font = [UIFont systemFontOfSize:16];
    [oneNavigator addTarget:self action:@selector(realNameBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:oneNavigator];
    [oneNavigator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@5);
        make.height.equalTo(@40);
        make.width.equalTo(@(kRectWidth * 0.25));
    }];
    
    MSCNavigatorView *twoNavigator = [[MSCNavigatorView alloc] init];
    [self addSubview:twoNavigator];
    [twoNavigator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneNavigator.mas_right);
        make.top.equalTo(@5);
        make.height.equalTo(@40);
        make.width.equalTo(@(kRectWidth * 0.75));
    }];
    

    twoNavigator.btnTitleArray = @[@"基本信息", @"安全设置", @"支付设置"];
    twoNavigator.badgeArray = @[@"0", @"0", @"0"];
    twoNavigator.defaultIndex = 0;
    
    
    __weak typeof(self) weakSelf = self;
    
    [twoNavigator returnBlock:^(NSInteger index) {
        [weakSelf.scrollView setContentOffset:CGPointMake(CGRectGetWidth(weakSelf.frame) * index, 0) animated:YES];
    }];
    
    
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(twoNavigator.mas_bottom);
    }];
    
    BaseMessageView *baseMessageView = [[BaseMessageView alloc] init];
    [scrollView addSubview:baseMessageView];
    [baseMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width);
    }];
    
    SecuritySettingsView *securitySettingView = [[SecuritySettingsView alloc] init];
    [scrollView addSubview:securitySettingView];
    [securitySettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(baseMessageView.mas_right);
        make.height.equalTo(baseMessageView.mas_height);
        make.width.equalTo(baseMessageView.mas_width);
    }];
    
    PaySettingsView *paySettingView = [[PaySettingsView alloc] init];
    [scrollView addSubview:paySettingView];
    [paySettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(securitySettingView.mas_right);
        make.top.equalTo(@0);
        make.height.equalTo(baseMessageView.mas_height);
        make.width.equalTo(baseMessageView.mas_width);
        make.right.equalTo(@0);
    }];
    
    _baseMessageView = baseMessageView;
    _paySettingView = paySettingView;
    _securitySettingView = securitySettingView;
    _twoNavigator = twoNavigator;
    _scrollView = scrollView;
    

}

- (void)setController:(UIViewController *)controller{
    _controller = controller;
    _securitySettingView.controller = controller;
    _baseMessageView.controller = controller;
    _paySettingView.controller = controller;
}

- (void)realNameBtnAction{
    
    RealNameAuthViewController *realVC = [[RealNameAuthViewController alloc] init];
    BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:realVC];
    [self.controller presentViewController:navC animated:YES completion:^{
        
    }];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger i = scrollView.contentOffset.x / CGRectGetWidth(self.frame);
    _twoNavigator.toIndex = i;
    
    
}


@end
