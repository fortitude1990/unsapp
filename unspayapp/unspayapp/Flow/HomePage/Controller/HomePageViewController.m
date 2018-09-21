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
#import "TabViewController.h"
#import "MeansView.h"
#import "SurprisedView.h"
#import "CheckItem.h"
#import "ContactView.h"
#import "RealNameAuthViewController.h"
#import "BindCardViewController.h"
#import "RechargeViewController.h"
#import "Pay_Password_ViewController.h"
#import "TransferAccountsViewController.h"
#import "SettingsViewController.h"



#define kMargin 15

typedef NS_ENUM(NSInteger, ScrollDirection) {
    ScrollDirectionNone,
    ScrollDirectionUp,
    ScrollDirectionDown
};

@interface HomePageViewController ()<UIScrollViewDelegate>
{
    UIImageView *_headImagView;
    UILabel *_nameLabel;
    ScrollDirection _scrollDirection;
    CGFloat _currentOffsetY;
    dispatch_semaphore_t _semaphore;
}

@property (strong, nonatomic) UIView * naviagtionView;

@property (strong, nonatomic) UIView * leftItemView;

@property (strong, nonatomic) UIView * headView;

@property (strong, nonatomic) UIScrollView * scrollView;

@property (strong, nonatomic) UIView * topBackgroundView;

@property (strong, nonatomic) UIView * controlStripView;

@property (strong, nonatomic) UIView * chameleon;

@property (strong, nonatomic) MeansView * meansView;

@property (strong, nonatomic) UIView * chameleonCover;


@end

@implementation HomePageViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.hidesBottomBarWhenPushed = NO;
    
    /*
    [[PopupAction defaultPopupAction] popupWithTitle:@"温馨提示" message:@"您还没有进行实名认证，请进行实名认证" ok:@"再看看" cancel:@"去实名认证" okAction:nil cancelAction:^{
        
        RealNameAuthViewController *realVC = [[RealNameAuthViewController alloc] init];
        BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:realVC];
        [self presentViewController:navC animated:YES completion:^{
            
        }];
        
    } of:self];
    */
    
    
    
    /*
    [[PopupAction defaultPopupAction] popupWithTitle:@"温馨提示" message:@"请绑定银行卡" ok:@"再看看" cancel:@"绑卡" okAction:nil cancelAction:^{
        
        BindCardViewController *realVC = [[BindCardViewController alloc] init];
        BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:realVC];
        [self presentViewController:navC animated:YES completion:^{
            
        }];
        
    } of:self];
    */
    
    /*
     [[PopupAction defaultPopupAction] popupWithTitle:@"温馨提示" message:@"请设置支付密码" ok:@"再看看" cancel:@"设置" okAction:nil cancelAction:^{
     
     Pay_Password_ViewController *realVC = [[Pay_Password_ViewController alloc] init];
         realVC.passwordInputType = PasswordInputTypeSimpleSetting;
     BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:realVC];
     [self presentViewController:navC animated:YES completion:^{
     
     }];
     
     } of:self];
     */
    
    
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
    
    
    CheckItem *checkBill = [[CheckItem alloc] init];
    checkBill.title = @"查看账单记录";
    [self.scrollView addSubview:checkBill];
    checkBill.frame = CGRectMake(0, CGRectGetMaxY(self.meansView.frame), kRectWidth, 50);
    
    UILabel *billRemindLabel = [[UILabel alloc] init];
    billRemindLabel.text = @"所有账单都在这里";
    billRemindLabel.font = [UIFont systemFontOfSize:13];
    billRemindLabel.textColor = KHexColor(0xb6b6b8);
    billRemindLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:billRemindLabel];
    billRemindLabel.frame = CGRectMake(0, CGRectGetMaxY(checkBill.frame) + 5, kRectWidth, 18);
    
    SurprisedView *surprisedView = [[SurprisedView alloc] init];
    [self.scrollView addSubview:surprisedView];
    surprisedView.frame = CGRectMake(0, CGRectGetMaxY(billRemindLabel.frame) + 25, kRectWidth, 25);
    
    ContactView *contactView = [[ContactView alloc] init];
    [self.scrollView addSubview:contactView];
    contactView.frame = CGRectMake(0, CGRectGetMaxY(surprisedView.frame) + 100, kRectWidth, 30);
    

    if (CGRectGetMaxY(contactView.frame) + 50 < kRectHeight - 64 + CGRectGetMinY(self.chameleon.frame)) {
        self.scrollView.contentSize = CGSizeMake(0, kRectHeight - 64 + CGRectGetMinY(self.chameleon.frame));
    }else{
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(contactView.frame) + 50);
    }
    
    
    UIView *meansBackView = [[UIView alloc] init];
    meansBackView.backgroundColor = [UIColor whiteColor];
    [self.scrollView insertSubview:meansBackView atIndex:0];
    
    meansBackView.frame = CGRectMake(0, CGRectGetMaxY(self.chameleon.frame), kRectWidth, self.scrollView.contentSize.height - CGRectGetMaxY(self.chameleon.frame));
    
    
    self.leftItemView.alpha = 0;

    
    [checkBill tapAction:^(BOOL flag, NSString *message) {
        
    }];
    
    [self.meansView tapAction:^(BOOL flag, NSString *message) {
        
    }];
    
}

#pragma mark - Set

- (void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed{
    
    [(TabViewController *)self.tabBarController setHiddenTabView:hidesBottomBarWhenPushed];
    
}

#pragma mark - Get

- (MeansView *)meansView{
    if (!_meansView) {
        
        MeansView *meansView = [[MeansView alloc] init];
        meansView.frame = CGRectMake(kMargin, CGRectGetMaxY(self.controlStripView.frame) + 15, kRectWidth - kMargin * 2, (kRectWidth - kMargin * 2) * 546 / 690.0);
        _meansView = meansView;
        
    }
    return _meansView;
}

- (UIView *)chameleon{
    
    if (!_chameleon) {
        
        _chameleon = [[UIView alloc] init];
        _chameleon.backgroundColor = self.controlStripView.backgroundColor;
        _chameleon.frame = CGRectMake(0, CGRectGetMaxY(self.controlStripView.frame), kRectWidth, CGRectGetHeight(self.topBackgroundView.frame) - CGRectGetMaxY(self.controlStripView.frame) - 64);
        
        self.chameleonCover = [[UIView alloc] init];
        self.chameleonCover.backgroundColor = [UIColor whiteColor];
        self.chameleonCover.alpha = 0;
        [_chameleon addSubview:self.chameleonCover];
        self.chameleonCover.frame = _chameleon.bounds;
        
    }
    
    return _chameleon;
}

- (UIView *)controlStripView{
    if (!_controlStripView) {
        
        _controlStripView = [[UIView alloc] init];
        _controlStripView.frame = CGRectMake(0, CGRectGetHeight(self.headView.frame), kRectWidth, 75);
        
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
    
    self.hidesBottomBarWhenPushed = YES;
    
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsVC animated:YES];
    
}

- (void)messageBtnAction{
    
}

- (void)rechargeBtnAction{
    
    RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rechargeVC animated:YES];
    
    
}

- (void)transferAccountsBtnAction{
    
    self.hidesBottomBarWhenPushed = YES;
    TransferAccountsViewController *transferAccountVC = [[TransferAccountsViewController alloc] init];
    [self.navigationController pushViewController:transferAccountVC animated:YES];
    
}

- (void)withdrawBtnAction{
    
    RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
    rechargeVC.tradingType = TradingTypeWithdraw;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rechargeVC animated:YES];
    
}

#pragma mark - Methods

- (void)startAlphaAnimation{
    
    CGFloat offsetY = self.scrollView.contentOffset.y;
    
    if (_currentOffsetY < offsetY) {
        _scrollDirection = ScrollDirectionDown;
    }else if (_currentOffsetY == offsetY) {
        _scrollDirection = ScrollDirectionNone;
    }else{
        _scrollDirection = ScrollDirectionUp;
    }
    
    _currentOffsetY = offsetY;
    
    if (_scrollDirection == ScrollDirectionUp) {
        self.hidesBottomBarWhenPushed = NO;
    }
    
    if (_scrollDirection == ScrollDirectionDown) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    
    if (offsetY <= CGRectGetMinY(self.chameleon.frame)) {
        self.headView.alpha = (CGRectGetHeight(self.headView.frame) - offsetY)/ CGRectGetHeight(self.headView.frame);
    }
    
    if (offsetY >= CGRectGetMinY(self.controlStripView.frame) && offsetY <= CGRectGetMinY(self.chameleon.frame)) {
        
        self.controlStripView.alpha = (CGRectGetMaxY(self.controlStripView.frame) - offsetY) / CGRectGetHeight(self.controlStripView.frame);
        self.leftItemView.alpha = (offsetY - CGRectGetMinY(self.controlStripView.frame)) / CGRectGetHeight(self.controlStripView.frame);
        self.chameleonCover.alpha = (offsetY - CGRectGetMinY(self.controlStripView.frame)) / CGRectGetHeight(self.controlStripView.frame);
    }
    
    
    if (offsetY < 5) {
        self.headView.alpha = 1;
        self.controlStripView.alpha = 1;
        self.chameleonCover.alpha = 0;
        self.leftItemView.alpha = 0;
    }
    
    if (offsetY >= CGRectGetMinY(self.chameleon.frame)) {
        self.headView.alpha = 0;
        self.controlStripView.alpha = 0;
        self.chameleonCover.alpha = 1;
        self.leftItemView.alpha = 1;
    }
    
    
}

#pragma mark - UIScrollViewDelegate



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
  [self startAlphaAnimation];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > 0 && offsetY < CGRectGetMinY(self.chameleon.frame)) {
//        if (_scrollDirection == ScrollDirectionUp) {
//            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
//        if (_scrollDirection == ScrollDirectionDown) {
//            [scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(self.chameleon.frame)) animated:YES];
//        }
//
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 0 && offsetY < CGRectGetMinY(self.chameleon.frame) && !decelerate) {

        if (_scrollDirection == ScrollDirectionUp) {
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }

        if (_scrollDirection == ScrollDirectionDown) {

        [scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(self.chameleon.frame)) animated:YES];
        }

    }
    
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 0 && offsetY < CGRectGetMinY(self.chameleon.frame)) {

        if (_scrollDirection == ScrollDirectionUp) {
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }

        if (_scrollDirection == ScrollDirectionDown) {

            [scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(self.chameleon.frame)) animated:YES];
        }


    }
    

    
}

@end
