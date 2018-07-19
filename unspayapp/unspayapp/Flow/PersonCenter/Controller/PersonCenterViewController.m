//
//  PersonCenterViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/12.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "AmplificationBtn.h"

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
}
@property (strong, nonatomic) UIView * naviagtionView;

@property (strong, nonatomic) UIView * headView;

@property (strong, nonatomic) UIView * topBackgroundView;

@property (strong, nonatomic) UIScrollView * scrollView;

@property (strong, nonatomic) UIView * controlStripView;

@property (nonatomic, strong) NSArray *btnsArray;

@end

@implementation PersonCenterViewController


#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
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
    
    self.view.backgroundColor = [UIColor colorWithRed:247/255. green:247/255. blue:247/255. alpha:1.0];
    
    [self.view addSubview:self.topBackgroundView];
    [self.view addSubview:self.naviagtionView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.controlStripView];
    
}

#pragma mark - Get

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
            
        }];
        
        [twoBtn btnAction:^{
            [self.btnsArray enumerateObjectsUsingBlock:^(AmplificationBtn * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (![obj isEqual:twoBtn]) {
                    obj.selected = NO;
                }
                
            }];
        }];
        
        [threeBtn btnAction:^{
            [self.btnsArray enumerateObjectsUsingBlock:^(AmplificationBtn * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (![obj isEqual:threeBtn]) {
                    obj.selected = NO;
                }
                
            }];
        }];
        
    }
    return _controlStripView;
}


#pragma mark - BtnActions

- (void)settingBtnAction{
    
}

- (void)messageBtnAction{
    
}


@end
