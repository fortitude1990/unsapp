//
//  PopupViewController.m
//  UNS5
//
//  Created by uns_apple02 on 16/3/18.
//  Copyright © 2016年 fortitude. All rights reserved.
//

#import "PopupViewController.h"


#define kHeight 200
#define kMargin 10

@interface PopupViewController ()

@property (nonatomic, strong)NSString *titleString;

@property (nonatomic, strong)NSString *message;

@property (nonatomic, strong)NSString *ok;

@property (nonatomic, strong)NSString *cancel;

@property (nonatomic, copy)PopupViewBack okAction;

@property (nonatomic, copy)PopupViewBack cancelAction;


@end

@implementation PopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message ok:(NSString *)ok cancel:(NSString *)cancel okAction:(PopupViewBack)okAction cancelAction:(PopupViewBack)cancelAction{
    
    self = [super init];
    if (self) {
        
        self.titleString = title;
        self.message = message;
        self.ok = ok;
        self.cancel = cancel;
        self.okAction = okAction;
        self.cancelAction = cancelAction;
        
    }
    return self;
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

- (void)createUI{
    
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    
    CGFloat y = (CGRectGetHeight(self.view.frame) - kHeight) * 90 / 218.0;
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 4;
    backView.clipsToBounds = YES;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kHeight));
        make.width.equalTo(@(kHeight * 13 / 9.0));
        make.centerX.equalTo(self.view);
        make.top.equalTo(@(y));
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.titleString;
    titleLabel.backgroundColor = [UIColor colorWithRed:238/255. green:238/255. blue:238/255. alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.height.equalTo(@48);
        make.width.equalTo(backView);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    UILabel *messageLabel = [UILabel new];
    messageLabel.text = self.message;
    messageLabel.textColor = [UIColor colorWithRed:74/255. green:74/255. blue:74/255. alpha:1.0];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.adjustsFontSizeToFitWidth = YES;
    [backView addSubview:messageLabel];
    messageLabel.font = [UIFont systemFontOfSize:16];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(@(kMargin));
        make.right.equalTo(@(-kMargin));
        make.bottom.equalTo(@(-50));
    }];
    
    if (self.cancel) {
        
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [okButton setTitle:self.ok forState:UIControlStateNormal];
        okButton.titleLabel.font = [UIFont systemFontOfSize:19];
        okButton.backgroundColor = [UIColor colorWithRed:229/255. green:242/255. blue:1.0 alpha:1.0];
        [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:okButton];
        [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(messageLabel.mas_bottom);
            make.bottom.equalTo(@0);
        }];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelButton setTitle:self.cancel forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:19];
        cancelButton.backgroundColor = [UIColor colorWithRed:229/255. green:242/255. blue:1.0 alpha:1.0];
        [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(okButton.mas_right).offset(1);
            make.right.equalTo(@0);
            make.top.equalTo(messageLabel.mas_bottom);
            make.bottom.equalTo(@0);
            make.width.equalTo(okButton);
        }];
        
    }else{
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [okButton setTitle:self.ok forState:UIControlStateNormal];
        okButton.titleLabel.font = [UIFont systemFontOfSize:19];
        okButton.backgroundColor = [UIColor colorWithRed:229/255. green:242/255. blue:1.0 alpha:1.0];
        [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:okButton];
        [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(messageLabel.mas_bottom);
            make.bottom.equalTo(@0);
        }];
    }
    

    
}

- (void)okButtonAction{
    
    __weak PopupViewController *weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.okAction();
    }];
    
}

- (void)cancelButtonAction{
    __weak PopupViewController *weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.cancelAction();
    }];
    
}
@end
