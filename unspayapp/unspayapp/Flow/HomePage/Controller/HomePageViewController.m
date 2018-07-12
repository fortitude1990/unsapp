//
//  HomePageViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/12.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageCollectionViewCell.h"
#import "HomePageItemModel.h"

#define kMargin 15

@interface HomePageViewController ()<UIScrollViewDelegate>
{
    UIImageView *_headImagView;
    UILabel *_nameLabel;
}

@property (strong, nonatomic) UIView * naviagtionView;

@property (strong, nonatomic) UIView * leftItemView;

@property (strong, nonatomic) UIView * headView;

@property (strong, nonatomic) UIScrollView * scrollView;

@property (strong, nonatomic) UIView * topBackgroundView;

@property (strong, nonatomic) UIView * controlStripView;

@property (strong, nonatomic) UIView * chameleon;

@property (strong, nonatomic) UIView * meansView;

@end

@implementation HomePageViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.topBackgroundView];
    [self.view addSubview:self.naviagtionView];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.controlStripView];
    [self.scrollView addSubview:self.chameleon];
    [self.scrollView addSubview:self.meansView];

    
    UIView *meansBackView = [[UIView alloc] init];
    meansBackView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:meansBackView];
    meansBackView.frame = CGRectMake(0, CGRectGetMaxY(self.chameleon.frame), kRectWidth, CGRectGetHeight(self.meansView.frame));
    
    self.scrollView.contentSize = CGSizeMake(0, 1000);

}

#pragma mark - Get

- (UIView *)meansView{
    if (!_meansView) {
        
        UIView *meansView = [[UIView alloc] init];
        meansView.backgroundColor = [UIColor whiteColor];
        meansView.frame = CGRectMake(kMargin, CGRectGetMaxY(self.controlStripView.frame) + 10, kRectWidth - kMargin * 2, 300);
        
        _meansView = meansView;
        
    }
    return _meansView;
}

- (UIView *)chameleon{
    
    if (!_chameleon) {
        _chameleon = [[UIView alloc] init];
        _chameleon.backgroundColor = self.controlStripView.backgroundColor;
        _chameleon.frame = CGRectMake(0, CGRectGetMaxY(self.controlStripView.frame), kRectWidth, CGRectGetHeight(self.topBackgroundView.frame) - CGRectGetMaxY(self.controlStripView.frame) - 64);
    }
    
    return _chameleon;
}

- (UIView *)controlStripView{
    if (!_controlStripView) {
        
        _controlStripView = [[UIView alloc] init];
        _controlStripView.frame = CGRectMake(0, CGRectGetHeight(self.headView.frame), kRectWidth, 80);
        
        //透明色不会产生阴影
        _controlStripView.backgroundColor = [KHexColor(0x3083FF) colorWithAlphaComponent:0.34];
//        _controlStripView.layer.shadowColor = [UIColor blackColor].CGColor;
//        _controlStripView.layer.shadowOffset = CGSizeMake(0, -0.01);
//        _controlStripView.layer.shadowOpacity = 0.8;
        
        

        
        CGFloat width = CGRectGetWidth(_controlStripView.frame);
        CGFloat height = CGRectGetHeight(_controlStripView.frame);
        CGFloat itemWidth = width / 3.0;
        
//        UIView *topLine = [[UIView alloc] init];
//        topLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//        [_controlStripView addSubview:topLine];
//        topLine.frame = CGRectMake(0, 0, width, 0.5);
        
        
        HomePageCollectionViewCell *recharge = [[HomePageCollectionViewCell alloc] init];
        [_controlStripView addSubview:recharge];
        recharge.frame = CGRectMake(0, 0, itemWidth, height);
        
        HomePageCollectionViewCell *transfer = [[HomePageCollectionViewCell alloc] init];
        [_controlStripView addSubview:transfer];
        transfer.frame = CGRectMake(itemWidth, 0, itemWidth, height);
        
        HomePageCollectionViewCell *withDraw = [[HomePageCollectionViewCell alloc] init];
        [_controlStripView addSubview:withDraw];
        withDraw.frame = CGRectMake(itemWidth * 2, 0, itemWidth, height);
        
        HomePageItemModel *rechargeModel = [[HomePageItemModel alloc] init];
        rechargeModel.title = @"充值";
        rechargeModel.itemImageName = @"充值-大";
        recharge.dataSource = rechargeModel;
        
        HomePageItemModel *transferModel = [[HomePageItemModel alloc] init];
        transferModel.title = @"转账";
        transferModel.itemImageName = @"转账-大";
        transfer.dataSource = transferModel;
        
        HomePageItemModel *withDrawModel = [[HomePageItemModel alloc] init];
        withDrawModel.title = @"提现";
        withDrawModel.itemImageName = @"提现-大";
        withDraw.dataSource = withDrawModel;
        
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rechargeBtnAction)];
        [recharge addGestureRecognizer:oneTap];
        
        UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transferAccountsBtnAction)];
        [transfer addGestureRecognizer:twoTap];
        
        UITapGestureRecognizer *threeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(withdrawBtnAction)];
        [withDraw addGestureRecognizer:threeTap];
        
    }
    return _controlStripView;
}

- (UIView *)headView{
    
    if (!_headView) {
        
        _headView = [[UIView alloc] init];
        _headView.frame = CGRectMake(0, 64, kRectWidth, 100);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor lightGrayColor];
        [_headView addSubview:imageView];
        imageView.frame = CGRectMake((CGRectGetWidth(_headView.frame) - 60) / 2.0,  7, 60, 60);
        
        imageView.layer.cornerRadius = 30;
        imageView.clipsToBounds = YES;
        
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.text = @"***";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:nameLabel];
        nameLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 15,CGRectGetWidth(_headView.frame), 22.5);
        
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
        
        self.leftItemView = [[UIView alloc] init];
        [_naviagtionView addSubview:self.leftItemView];
        self.leftItemView.frame = CGRectMake(0, 0, CGRectGetMinX(messageBtn.frame), height);
        
        
        UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rechargeBtn setImage:[UIImage imageNamed:@"充值-小"] forState:UIControlStateNormal];
        rechargeBtn.tintColor = [UIColor whiteColor];
        [rechargeBtn addTarget:self action:@selector(rechargeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.leftItemView addSubview:rechargeBtn];
        rechargeBtn.frame = CGRectMake(kMargin, originY, itemWidth, itemWidth);
        
        UIButton *transferBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        transferBtn.tintColor = [UIColor whiteColor];
        [transferBtn setImage:[UIImage imageNamed:@"转账-小"] forState:UIControlStateNormal];
        [transferBtn addTarget:self action:@selector(transferAccountsBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.leftItemView addSubview:transferBtn];
        transferBtn.frame = CGRectMake(CGRectGetMaxX(rechargeBtn.frame) + kMargin, originY, itemWidth, itemWidth);
        
        UIButton *withDrawBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        withDrawBtn.tintColor = [UIColor whiteColor];
        [withDrawBtn setImage:[UIImage imageNamed:@"提现-小"] forState:UIControlStateNormal];
        [withDrawBtn addTarget:self action:@selector(withdrawBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.leftItemView addSubview:withDrawBtn];
        withDrawBtn.frame = CGRectMake(CGRectGetMaxX(transferBtn.frame) + kMargin, originY, itemWidth, itemWidth);
        
    }
    return _naviagtionView;
}

#pragma mark - BtnActions

- (void)settingBtnAction{
    
}

- (void)messageBtnAction{
    
}

- (void)rechargeBtnAction{
    
}

- (void)transferAccountsBtnAction{
    
}

- (void)withdrawBtnAction{
    
}

#pragma mark - Methods

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    

    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

@end
