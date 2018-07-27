//
//  BankCardView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//



#import "BankCardView.h"
#import "BankCardShowTableViewCell.h"
#import "ShadowView.h"
#import "NextButton.h"
#import "PersonCenterViewController.h"
#import "BindCardViewController.h"

#define kItemHeight 50
#define kMargin 15

static NSString *bankCardTableViewCellIdentifier = @"bankCardTableViewCellIdentifier";

@interface BankCardView()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)ShadowView *shadowView;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, assign)CGFloat offsetY;

@end

@implementation BankCardView

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

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self createUI];

}

- (void)setController:(UIViewController *)controller{
    _controller = controller;
}

- (void)createUI{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.bounces = NO;
    [self addSubview:scrollView];
    scrollView.frame = CGRectMake(0, 0, kRectWidth, CGRectGetHeight(self.frame));
    
    ShadowView *shadowView = [[ShadowView alloc] init];
    shadowView.frame = CGRectMake(kMargin, kMargin, kRectWidth - kMargin * 2, 200);
    [scrollView addSubview:shadowView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kRectWidth - kMargin * 2, 200) style:UITableViewStylePlain];
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [shadowView addSubview:tableView];
    
    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [tableView registerNib:[UINib nibWithNibName:@"BankCardShowTableViewCell" bundle:nil] forCellReuseIdentifier:bankCardTableViewCellIdentifier];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 44 + 44 + 25);
    tableView.tableFooterView = footerView;
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = tableView.separatorColor;
    [footerView addSubview:topLine];
    topLine.frame = CGRectMake(0, 0, CGRectGetWidth(footerView.frame), 0.5);
    
    NextButton *nextBtn = [[NextButton alloc] init];
    [nextBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextBtn];
    nextBtn.frame = CGRectMake(kMargin, 44, CGRectGetWidth(footerView.frame) - kMargin * 2, 44);
    [nextBtn canResponse];
    
    self.tableView = tableView;
    self.shadowView = shadowView;
    self.scrollView = scrollView;
    
    self.dataArray = (NSMutableArray *)@[@"",@"",@""];
    [self changeFrame];
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        PersonCenterViewController *vc =  (PersonCenterViewController *)self.controller;
        if(vc){
            self.scrollView.scrollEnabled = NO;
            [vc subviewsCanScroll:^(BOOL flag, NSString *message) {
                if (flag) {
                    self.scrollView.scrollEnabled = YES;
                }else{
                    self.scrollView.scrollEnabled = NO;
                }
            }];
        }
        
    });
}

- (void)changeFrame{
    
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height = self.dataArray.count * kItemHeight + 44 + 44 + 25;
    self.tableView.frame = tableViewFrame;
    
    CGRect shadowViewFrame = self.shadowView.frame;
    shadowViewFrame.size.height = self.tableView.frame.size.height;
    self.shadowView.frame = shadowViewFrame;
    
    self.scrollView.contentSize = CGSizeMake(kRectWidth, CGRectGetMaxY(self.shadowView.frame) + kMargin);
    
}

- (void)nextBtnAction{
    
    BindCardViewController *bindVC = [[BindCardViewController alloc] init];
    BaseNavController *navC = [[BaseNavController alloc] initWithRootViewController:bindVC];
    [self.controller presentViewController:navC animated:YES completion:^{
        
    }];
    
}

- (UIViewController *)viewControllerSupportView:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    PersonCenterViewController *vc =  (PersonCenterViewController *)[self viewControllerSupportView:self];
    if (scrollView.contentOffset.y > self.offsetY) {
        vc.hidesBottomBarWhenPushed = YES;
    }else{
        vc.hidesBottomBarWhenPushed = NO;
    }
    
    self.offsetY = scrollView.contentOffset.y;
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kItemHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BankCardShowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:bankCardTableViewCellIdentifier forIndexPath:indexPath];
    return cell;
    
}

@end
