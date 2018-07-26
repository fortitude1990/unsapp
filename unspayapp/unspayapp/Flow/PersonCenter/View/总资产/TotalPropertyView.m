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

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    backView.layer.shadowOffset = CGSizeMake(2, 2);
    backView.layer.shadowOpacity = 0.8;
    backView.layer.shadowRadius = 2;
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PersonCenterViewController *vc =  (PersonCenterViewController *)[self viewControllerSupportView:self];
        if(vc){
            tableView.scrollEnabled = NO;
            [vc subviewsCanScroll:^(BOOL flag, NSString *message) {
                if (flag) {
                    tableView.scrollEnabled = YES;
                    headerView.frame = CGRectMake(0, 0, 0, 0);
                    tableView.tableHeaderView = headerView;
                }else{
                    tableView.scrollEnabled = NO;
                    headerView.frame = CGRectMake(0, 0, kRectWidth, kAutoScaleNormal(420));
                    tableView.tableHeaderView = headerView;
                }
            }];
        }
    });
    

    
    

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
