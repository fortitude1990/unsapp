//
//  PersonCenterViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/12.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "AmplificationBtn.h"
#import "TabViewController.h"
#import "AccountView.h"
#import "TotalPropertyView.h"
#import "BankCardView.h"


#define kMargin 15

typedef NS_ENUM(NSInteger, ScrollDirection) {
    ScrollDirectionNone,
    ScrollDirectionUp,
    ScrollDirectionDown
};

@interface PersonCenterViewController ()<UIScrollViewDelegate>
{
    UIImageView *_headImagView;
    UILabel *_nameLabel;
    ScrollDirection _scrollDirection;
    CGFloat _currentOffsetY;
    dispatch_semaphore_t _semaphore;
    AmplificationBtn *_topAmplificationView;
    UILabel *_topTitleLabel;
    
}

@property (strong, nonatomic) UIView * naviagtionView;

@property (strong, nonatomic) UIView * headView;

@property (strong, nonatomic) UIView * topBackgroundView;

@property (strong, nonatomic) UIScrollView * scrollView;

@property (strong, nonatomic) UIView * controlStripView;

@property (nonatomic, strong) NSArray *btnsArray;

@property (strong, nonatomic) UIView * topView;

@property (strong, nonatomic) AccountView *accountView;

@property (strong, nonatomic) TotalPropertyView *totalPropertyView;

@property (strong, nonatomic) BankCardView *bankCardView;

@property (strong, nonatomic) NSMutableArray *blockArray;

@end

@implementation PersonCenterViewController


#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.hidesBottomBarWhenPushed = NO;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CreateUI

- (void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:247/255. green:247/255. blue:247/255. alpha:1.0];
    
    [self.view addSubview:self.topBackgroundView];
    [self.view addSubview:self.naviagtionView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.controlStripView];
    [self.view addSubview:self.topView];

    self.scrollView.contentSize = CGSizeMake(0, kRectHeight - 63 + CGRectGetHeight(self.headView.frame));
    
    
    UIView *meansBackView = [[UIView alloc] init];
    meansBackView.backgroundColor = [UIColor whiteColor];
    [self.scrollView insertSubview:meansBackView atIndex:0];
    meansBackView.frame = CGRectMake(0, CGRectGetMaxY(self.controlStripView.frame), kRectWidth, self.scrollView.contentSize.height - CGRectGetMaxY(self.controlStripView.frame));
    
    AccountView *accountView = [[AccountView alloc] init];
    accountView.controller = self;
    [self.scrollView addSubview:accountView];
    accountView.frame = meansBackView.frame;
    
    TotalPropertyView *totalPropertyView = [[TotalPropertyView alloc] init];
    totalPropertyView.controller = self;
    totalPropertyView.frame = meansBackView.frame;

    BankCardView *bankCardView = [[BankCardView alloc] init];
    bankCardView.controller = self;
    bankCardView.frame = meansBackView.frame;
    
    _accountView = accountView;
    _totalPropertyView = totalPropertyView;
    _bankCardView = bankCardView;
    
}

#pragma mark - Set

- (void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed{
    
    [(TabViewController *)self.tabBarController setHiddenTabView:hidesBottomBarWhenPushed];
    
}

#pragma mark - Get

- (NSMutableArray *)blockArray{
    if (!_blockArray) {
        _blockArray = [NSMutableArray array];
    }
    return _blockArray;
}

- (UIView *)topView{
    if (!_topView) {
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 64, kRectWidth, CGRectGetHeight(self.headView.frame));
        
        AmplificationBtn *selectBtn;
        
        for (AmplificationBtn *btn in self.btnsArray) {
            if (btn.selected == YES) {
                selectBtn = btn;
                break;
            }
        }
        
        AmplificationBtn *btn = [[AmplificationBtn alloc] init];
        btn.title = selectBtn.title;
        btn.imageName = selectBtn.imageName;
        btn.selected = NO;
        [view addSubview:btn];
        btn.frame = CGRectMake(0, 0, kRectWidth / 3.0, CGRectGetHeight(view.frame));
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(32)];
        titleLabel.textColor = [UIColor whiteColor];
        [view addSubview:titleLabel];
        titleLabel.frame = CGRectMake(CGRectGetMaxX(btn.frame) + 5, 10, 150, kAutoScaleNormal(116));
        
        if (_nameLabel) {
            titleLabel.text = _nameLabel.text;
        }
        
        _topAmplificationView = btn;
        _topTitleLabel = titleLabel;
        _topView = view;
        
        _topView.alpha = 0;
    }
    
    return _topView;
}


- (UIView *)naviagtionView{
    
    if (!_naviagtionView) {
        
        _naviagtionView = [[UIView alloc] init];
        _naviagtionView.frame = CGRectMake(0, 0, kRectWidth, 64);
        
        CGFloat width = CGRectGetWidth(_naviagtionView.frame);
        CGFloat height = CGRectGetHeight(_naviagtionView.frame);
        
        CGFloat itemWidth = 30;
        CGFloat originY = 20 +  (height - 20 - 30) / 2.0;
        
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [settingBtn setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
        settingBtn.tintColor = [UIColor whiteColor];
        [settingBtn addTarget:self action:@selector(settingBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_naviagtionView addSubview:settingBtn];
        settingBtn.frame = CGRectMake(width - itemWidth - kMargin, originY, itemWidth, itemWidth);
        
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        messageBtn.tintColor = [UIColor whiteColor];
        [messageBtn setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
        [messageBtn addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_naviagtionView addSubview:messageBtn];
        messageBtn.frame = CGRectMake(CGRectGetMinX(settingBtn.frame) - itemWidth - kMargin, originY, itemWidth, itemWidth);
        
       
    }
    return _naviagtionView;
}

- (UIView *)headView{
    
    if (!_headView) {
        
        _headView = [[UIView alloc] init];
        _headView.frame = CGRectMake(0, 0, kRectWidth, 100);
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"默认头像"]];
        imageView.backgroundColor = [UIColor lightGrayColor];
        [_headView addSubview:imageView];
        imageView.frame = CGRectMake((CGRectGetWidth(_headView.frame) - 60) / 2.0,  7, 60, 60);
        
        imageView.layer.cornerRadius = 30;
        imageView.clipsToBounds = YES;
        
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.text = @"李志敬";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:nameLabel];
        nameLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 5,CGRectGetWidth(_headView.frame), 22.5);
        
        _headImagView = imageView;
        _nameLabel = nameLabel;
        
    }
    return _headView;
}

- (UIView *)topBackgroundView{
    if (!_topBackgroundView) {
        _topBackgroundView = [[UIView alloc] init];
        _topBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"首页背景"]];
        _topBackgroundView.frame = CGRectMake(0, 0, kRectWidth, 265);
    }
    
    return _topBackgroundView;
}

- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.frame = CGRectMake(0, 64, kRectWidth, kRectHeight - 64);
    }
    
    return _scrollView;
}

- (UIView *)controlStripView{
    if (!_controlStripView) {
        
        _controlStripView = [[UIView alloc] init];
        _controlStripView.frame = CGRectMake(0, CGRectGetHeight(self.headView.frame), kRectWidth, CGRectGetHeight(self.topBackgroundView.frame) - 64 - CGRectGetHeight(self.headView.frame));
        
        CGFloat width = CGRectGetWidth(_controlStripView.frame);
        CGFloat height = CGRectGetHeight(_controlStripView.frame);
        
        AmplificationBtn *oneBtn = [[AmplificationBtn alloc] init];
        oneBtn.title = @"账户";
        oneBtn.imageName = @"账户-大";
        oneBtn.selected = YES;
        [_controlStripView addSubview:oneBtn];
        oneBtn.frame = CGRectMake(0, 0, width / 3.0, height);
        
        AmplificationBtn *twoBtn = [[AmplificationBtn alloc] init];
        twoBtn.title = @"总资产";
        twoBtn.imageName = @"总资产-大";
        [_controlStripView addSubview:twoBtn];
        twoBtn.frame = CGRectMake(width / 3.0, 0, width / 3.0, height);
        
        AmplificationBtn *threeBtn = [[AmplificationBtn alloc] init];
        threeBtn.title = @"银行卡";
        threeBtn.imageName = @"银行卡-大";
        [_controlStripView addSubview:threeBtn];
        threeBtn.frame = CGRectMake(width * 2 / 3.0, 0, width / 3.0, height);
        
        self.btnsArray = @[oneBtn,twoBtn,threeBtn];
        
        [oneBtn btnAction:^{
            
            [self.btnsArray enumerateObjectsUsingBlock:^(AmplificationBtn * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (![obj isEqual:oneBtn]) {
                    obj.selected = NO;
                }
                
            }];
            
            [self changeTopViewValue];
            
            [self.scrollView addSubview:self.accountView];
            if ([self.scrollView.subviews containsObject:self.totalPropertyView]) {
                [self.totalPropertyView removeFromSuperview];
            }
            if ([self.scrollView.subviews containsObject:self.bankCardView]) {
                [self.bankCardView removeFromSuperview];
            }
        }];
        
        [twoBtn btnAction:^{
            
            [self.btnsArray enumerateObjectsUsingBlock:^(AmplificationBtn * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (![obj isEqual:twoBtn]) {
                    obj.selected = NO;
                }
                
            }];
            
            [self changeTopViewValue];
            
            [self.scrollView addSubview:self.totalPropertyView];
            if ([self.scrollView.subviews containsObject:self.accountView]) {
                [self.accountView removeFromSuperview];
            }
            if ([self.scrollView.subviews containsObject:self.bankCardView]) {
                [self.bankCardView removeFromSuperview];
            }
            
        }];
        
        [threeBtn btnAction:^{
            
            [self.btnsArray enumerateObjectsUsingBlock:^(AmplificationBtn * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (![obj isEqual:threeBtn]) {
                    obj.selected = NO;
                }
                
            }];
            
            [self changeTopViewValue];
            
            [self.scrollView addSubview:self.bankCardView];
            if ([self.scrollView.subviews containsObject:self.accountView]) {
                [self.accountView removeFromSuperview];
            }
            if ([self.scrollView.subviews containsObject:self.totalPropertyView]) {
                [self.totalPropertyView removeFromSuperview];
            }
            
        }];
        
    }
    return _controlStripView;
}


#pragma mark - BtnActions



- (void)settingBtnAction{
    
}

- (void)messageBtnAction{
    
}

#pragma mark - Methods

- (void)subviewsCanScroll:(CommonBlock)bock{
    
    if (bock) {
        
        [self.blockArray addObject:bock];
        
//        if (!self.myBlock) {
//            self.myBlock = bock;
//        }
    }
    
}

- (void)changeTopViewValue{
    
    
    AmplificationBtn *selectBtn;
    
    for (AmplificationBtn *btn in self.btnsArray) {
        if (btn.selected == YES) {
            selectBtn = btn;
            break;
        }
    }
    
    _topAmplificationView.title = selectBtn.title;
    _topAmplificationView.imageName = selectBtn.imageName;
    _topTitleLabel.text = _nameLabel.text;
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    

    
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > _currentOffsetY) {
        _scrollDirection = ScrollDirectionDown;
    }else{
        _scrollDirection = ScrollDirectionUp;
    }
    
    _currentOffsetY = offsetY;
    
    
    if (_scrollDirection == ScrollDirectionUp) {
        self.hidesBottomBarWhenPushed = NO;
    }else{
        self.hidesBottomBarWhenPushed = YES;
    }
    
    
    if (offsetY <= CGRectGetMaxY(self.headView.frame)) {
        
        self.headView.alpha = (CGRectGetMaxY(self.headView.frame) - offsetY) / CGRectGetMaxY(self.headView.frame);
        self.controlStripView.alpha = (CGRectGetMaxY(self.headView.frame) - offsetY) / CGRectGetMaxY(self.headView.frame);
        self.topView.alpha = offsetY / CGRectGetMaxY(self.headView.frame);

        
    }
    
    
    if (offsetY > 0 && offsetY < CGRectGetMaxY(self.headView.frame) ){
        _topAmplificationView.selected = NO;
    }
    
    if(offsetY == 0){
        self.headView.alpha = 1;
        self.controlStripView.alpha = 1;
        self.topView.alpha = 0;
        _topAmplificationView.selected = NO;
    }
    
    if (offsetY >= CGRectGetMaxY(self.headView.frame)) {
        self.headView.alpha = 0;
        self.controlStripView.alpha = 0;
        self.topView.alpha = 1;
        _topAmplificationView.selected = YES;
    }

    
    
    
    
    if (self.blockArray) {
        if (offsetY >= CGRectGetMaxY(self.headView.frame)) {
            for (CommonBlock block in self.blockArray) {
                block(YES, [NSString stringWithFormat:@"%lf", offsetY]);
            }
//            self.myBlock(YES, [NSString stringWithFormat:@"%lf", offsetY]);
        }else{
            for (CommonBlock block in self.blockArray) {
                block(NO, [NSString stringWithFormat:@"%lf", offsetY]);
            }
//            self.myBlock(NO, [NSString stringWithFormat:@"%lf", offsetY]);
        }
    }
    

    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > 0 && offsetY < CGRectGetMaxY(self.headView.frame) && !decelerate) {
        
        if (_scrollDirection == ScrollDirectionUp) {
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        if (_scrollDirection == ScrollDirectionDown) {
            
            [scrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(self.headView.frame) + 1) animated:YES];
        }
        
    }
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > 0 && offsetY < CGRectGetMaxY(self.headView.frame)) {
        
        if (_scrollDirection == ScrollDirectionUp) {
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        if (_scrollDirection == ScrollDirectionDown) {
            
            [scrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(self.headView.frame) + 1) animated:YES];
        }
        
        
    }
    
    
    
}


@end
