//
//  TotalPropertyView.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "TotalPropertyView.h"
#import "RechargeRecordTableViewCell.h"
#import "PersonCenterViewController.h"
#import "TabViewController.h"
#import "AmountShowView.h"
#import "GradientView.h"
#import "ShadowView.h"

static NSString *totalPropertyViewTableViewCellIdentifier = @"totalPropertyViewTableViewCellIdentifier";

@interface TotalPropertyView()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
{
    dispatch_semaphore_t _semaphore;
    UILabel *_unitLabel;
    UIView *_amountBackView;
    UILabel *_amountLabel;
    UIView *_backView;
}

@property (nonatomic, assign)CGFloat offsetY;

@property (nonatomic, strong)NSString *amount;

@end

@implementation TotalPropertyView

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
    
    _semaphore = dispatch_semaphore_create(1);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.bounces = NO;
    tableView.dataSource = self;
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    [tableView registerNib:[UINib nibWithNibName:@"RechargeRecordTableViewCell" bundle:nil] forCellReuseIdentifier:totalPropertyViewTableViewCellIdentifier];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRectWidth, kAutoScaleNormal(420))];
    headerView.clipsToBounds = YES;
    tableView.tableHeaderView = headerView;

    /*
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    backView.layer.shadowOffset = CGSizeMake(2, 2);
    backView.layer.shadowOpacity = 0.8;
    backView.layer.shadowRadius = 2;
    [headerView addSubview:backView];
    backView.frame = CGRectMake(15, kAutoScaleNormal(30), kRectWidth - 30, kAutoScaleNormal(380));
    */
    
    ShadowView *backView = [[ShadowView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:backView];
    backView.frame = CGRectMake(15, kAutoScaleNormal(30), kRectWidth - 30, kAutoScaleNormal(380));
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"总资产";
    titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(0,kAutoScaleNormal(30), CGRectGetWidth(backView.frame), kAutoScaleNormal(42));

    
    UIView *amountBackView = [[UIView alloc] init];
//    amountBackView.backgroundColor = [UIColor orangeColor];
    [backView addSubview:amountBackView];
    amountBackView.frame = CGRectMake((CGRectGetWidth(backView.frame) - 100) / 2.0, CGRectGetMaxY(titleLabel.frame) + kAutoScaleNormal(26), 100, kAutoScaleNormal(89));
   
    UILabel *unitLabel = [[UILabel alloc] init];
    unitLabel.text = @"￥";
    unitLabel.textColor = KHexColor(0xFF821D);
    unitLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    [amountBackView addSubview:unitLabel];
    unitLabel.frame = CGRectMake(0, 0, kAutoScaleNormal(30), CGRectGetHeight(amountBackView.frame));

    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = @"60";
    amountLabel.textColor = KHexColor(0xFF821D);
    amountLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(68)];
    [amountBackView addSubview:amountLabel];
    amountLabel.frame = CGRectMake(CGRectGetMaxX(unitLabel.frame), 0, 60, kAutoScaleNormal(89));

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = KHexColor(0xe9e9e9);
    [backView addSubview:line];
    line.frame = CGRectMake(0, CGRectGetMaxY(amountBackView.frame) + kAutoScaleNormal(31), CGRectGetWidth(backView.frame), 0.5);
    
    UIView *bottomView = [[UIView alloc] init];
    [backView addSubview:bottomView];
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(line.frame), CGRectGetWidth(backView.frame), CGRectGetHeight(backView.frame) - CGRectGetMaxY(line.frame));
    
    AmountShowView *useAmountView = [[AmountShowView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bottomView.frame) / 3.0, CGRectGetHeight(bottomView.frame))];
    useAmountView.title = @"可用资产";
    useAmountView.amount = @"￥6000.00";
    [bottomView addSubview:useAmountView];
    
    AmountShowView *thisMonthAmountView = [[AmountShowView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(useAmountView.frame), 0, CGRectGetWidth(bottomView.frame) / 3.0, CGRectGetHeight(bottomView.frame))];
    thisMonthAmountView.title = @"可用资产";
    thisMonthAmountView.amount = @"￥6000.00";
    [bottomView addSubview:thisMonthAmountView];
    
    AmountShowView *thisMonthIncomeView = [[AmountShowView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(thisMonthAmountView.frame), 0, CGRectGetWidth(bottomView.frame) / 3.0, CGRectGetHeight(bottomView.frame))];
    thisMonthIncomeView.title = @"可用资产";
    thisMonthIncomeView.amount = @"￥6000.00";
    [bottomView addSubview:thisMonthIncomeView];
    
    GradientView *oneGradientView = [[GradientView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(useAmountView.frame) - 0.25, 0, 0.5, CGRectGetHeight(bottomView.frame))];
    [bottomView addSubview:oneGradientView];
    
    GradientView *twoGradientView = [[GradientView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(thisMonthAmountView.frame) - 0.25, 0, 0.5, CGRectGetHeight(bottomView.frame))];
    [bottomView addSubview:twoGradientView];
    
    _backView = backView;
    _amountBackView = amountBackView;
    _unitLabel = unitLabel;
    _amountLabel = amountLabel;
   
    self.amount = @"1.00";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PersonCenterViewController *vc =  (PersonCenterViewController *)self.controller;
        if(vc){
            tableView.scrollEnabled = NO;
            [vc subviewsCanScroll:^(BOOL flag, NSString *message) {
                if (flag) {
                    tableView.scrollEnabled = YES;
                    headerView.frame = CGRectMake(0, 0, 0, 0);
                    tableView.tableHeaderView = headerView;
                }else{
                    
                    CGFloat offsetY = [message floatValue];
                    
                    if (100 - offsetY > 0) {
                        headerView.frame = CGRectMake(0, 0, kRectWidth, kAutoScaleNormal(420) * (100 - offsetY) / 100.00);
                        headerView.alpha = (100 - offsetY) / 100.00;
                    }else{
                        headerView.frame = CGRectMake(0, 0, kRectWidth, kAutoScaleNormal(420));
                        headerView.alpha = 1;
                    }
                    
                    
                    tableView.scrollEnabled = NO;
                    tableView.tableHeaderView = headerView;
                }
            }];
        }
    });
    

    
    

}

- (void)setController:(UIViewController *)controller{
    _controller = controller;

}

- (void)setAmount:(NSString *)amount{
    
    _amount = amount;
    _amountLabel.text = _amount;
    CGFloat width = [self widthOfString:amount];
    
    CGRect amountLabelFrame = _amountLabel.frame;
    amountLabelFrame.size.width = width;
    _amountLabel.frame = amountLabelFrame;
    
    CGRect backViewFrame = _amountBackView.frame;
    backViewFrame.origin.x = (CGRectGetWidth(_backView.frame) - width - CGRectGetWidth(_unitLabel.frame)) / 2.0;
    backViewFrame.size.width = width + CGRectGetWidth(_unitLabel.frame);
    _amountBackView.frame = backViewFrame;
    
    
}

- (CGFloat)widthOfString:(NSString *)string{
    return [string sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kAutoScaleNormal(68)]}].width;
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

- (void)selectBtnAction{
    
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
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *itemHeaderView = [[UIView alloc] init];
    itemHeaderView.backgroundColor = [UIColor whiteColor];
    itemHeaderView.frame = CGRectMake(0, 0, kRectWidth, 50);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"支付账单"]];
    [itemHeaderView addSubview:imageView];
    imageView.frame = CGRectMake(15, (CGRectGetHeight(itemHeaderView.frame) - 30) / 2.0, 30, 30);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"支付账单";
    titleLabel.font = [UIFont systemFontOfSize:kAutoScaleNormal(30)];
    [itemHeaderView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 5, CGRectGetMinY(imageView.frame), 150, 30);
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectBtn setTitle:@"账单种类" forState:UIControlStateNormal];
    [selectBtn setTitleColor:KHexColor(0x0068b7) forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [itemHeaderView addSubview:selectBtn];
    selectBtn.frame = CGRectMake(CGRectGetWidth(itemHeaderView.frame) - 15 - kAutoScaleNormal(150), CGRectGetMinY(imageView.frame), kAutoScaleNormal(150), 30);
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = tableView.separatorColor;
    [itemHeaderView addSubview:lineView];
    lineView.frame = CGRectMake(15, CGRectGetHeight(itemHeaderView.frame) - 0.5, kRectWidth - 30, 0.5);
    
    return itemHeaderView;
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RechargeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:totalPropertyViewTableViewCellIdentifier forIndexPath:indexPath];
    cell.recordListType = RecordListTypeTotalProperty;
    return cell;
}



@end
