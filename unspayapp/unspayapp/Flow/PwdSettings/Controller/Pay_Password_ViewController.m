//
//  Pay_Password_ViewController.m
//  QuickPayment
//
//  Created by 李志敬 on 16/7/7.
//  Copyright © 2016年 李志敬. All rights reserved.
//

#import "Pay_Password_ViewController.h"
#import "KeyboardView.h"
#import "PointView.h"

@interface Pay_Password_ViewController ()

@property (nonatomic, strong)NSMutableString *password;

@property (nonatomic, strong)NSMutableArray *boxArray;

@property (nonatomic, strong)UIButton *nextBtn;

@property (nonatomic, strong)UILabel *label;

@property (nonatomic, strong)NSString *password_one;

@end

@implementation Pay_Password_ViewController

#pragma mark ------------------ lifeCycle -----------------

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if (self.passwordInputType == PasswordInputTypeDefault) {
        self.navigationItem.title = @"输入密码";
        self.label.text = @"请输入支付密码，验证身份";
    }else if(self.passwordInputType == PasswordInputTypeSimpleSetting || self.passwordInputType == PasswordInputTypeCompoundSetting){
        self.navigationItem.title = @"设置密码";
        self.label.text = @"请设置支付密码，用于支付验证。";
    }else{
        self.navigationItem.title = @"修改密码";
        self.label.text = @"请设置支付密码，用于支付验证。";
    }
    
    
    
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
//    self.indicatorView = [[IndicatorView alloc] initWithFrame:self.view.frame];
    
    if (self.passwordInputType == PasswordInputTypeDefault) {
        [self resume];
    }
    

    
}

#pragma mark ------------------ action -----------------

- (void)createUI{
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255. green:239/255. blue:244/255. alpha:1.0];
    
    self.password = [NSMutableString string];
    
    
    KeyboardView *keyboard = [[KeyboardView alloc] initWithFrame:CGRectMake(0, kRectHeight - 216, kRectWidth, 216)];
    [keyboard sendValue:^(NSString *backValue) {
        if ([backValue isEqualToString:@"del"]) {
            
            if (self.password.length > 0) {
                [self clearPassword:backValue];
            }
            
        }else{
            
            if (self.password.length >= 6) {
                return ;
            }else{
                [self showPassword:backValue];
            }


        }
        NSLog(@"password: %@", self.password);
        
    }];
    [self.view addSubview:keyboard];
    
    CGFloat originY = (kRectHeight - 216 - 110) / 2.0;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, originY, kRectWidth, 30)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"请输入支付密码，验证身份";
    self.label.font = [UIFont systemFontOfSize:17];
    self.label.textColor = [UIColor colorWithRed:36/255. green:36/255. blue:45/255. alpha:1.0];
    [self.view addSubview:self.label];
    
    
    UIView *passwordBoxView = [self createBox];
    CGRect frame = passwordBoxView.frame;
    frame.origin.x = (kRectWidth - frame.size.width) / 2.0;
    frame.origin.y = CGRectGetMaxY(self.label.frame) + 40;
    passwordBoxView.frame = frame;
    [self.view addSubview:passwordBoxView];
    
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
//        NSLog(@"%lf", [[UIScreen mainScreen] bounds].size.height);
        self.nextBtn.frame = CGRectMake(23, CGRectGetMaxY(passwordBoxView.frame) + 20, kRectWidth - 46, 44);
        
    }else{
        self.nextBtn.frame = CGRectMake(23, CGRectGetMaxY(passwordBoxView.frame) + 40, kRectWidth - 46, 44);
    }
    self.nextBtn.layer.cornerRadius = 22;
    self.nextBtn.clipsToBounds = YES;
    self.nextBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    self.nextBtn.tintColor = [UIColor whiteColor];
    self.nextBtn.backgroundColor = [UIColor colorWithRed:67/255. green:109/255. blue:227/255. alpha:1.0];
    self.nextBtn.alpha = 0;
    [self.view addSubview:self.nextBtn];
    
    
    
}

- (void)nextButtonAction{
 
    
    [self networking];
    
}


- (UIView *)createBox{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderColor = [UIColor colorWithRed:159/255. green:159/255. blue:159/255. alpha:1.0].CGColor;
    backView.layer.borderWidth = 1 ;
    
    self.boxArray = [NSMutableArray arrayWithCapacity:6];
    
    for (int i = 0; i < 6; i++) {
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40 * i, 0, 40, 40)];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.layer.borderColor = [UIColor colorWithRed:159/255. green:159/255. blue:159/255. alpha:1.0].CGColor;
//        label.layer.borderWidth = 0.5;
//        label.font = [UIFont systemFontOfSize:60];
////        label.backgroundColor = [UIColor redColor];
//        [backView addSubview:label];
//        [self.boxArray addObject:label];
        


        
        PointView *pointView = [[PointView alloc] initWithFrame:CGRectMake(40 * i, 0, 40, 40)];

        pointView.alpha = 0;
        [backView addSubview:pointView];
        [self.boxArray addObject:pointView];

        if (i > 0 && i < 6) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(40 * i, 0, 1, 40)];
            lineView.backgroundColor = [UIColor colorWithRed:159/255. green:159/255. blue:159/255. alpha:1.0];
            [backView addSubview:lineView];
        }
        
        
    }
    
    
    return backView;
}

- (void)showPassword: (NSString *)str{
    
//    UILabel *label = self.boxArray[self.password.length];
//    label.text = @"·";
    
     PointView *pointView = self.boxArray[self.password.length];
    pointView.alpha = 1;
    
    
    self.password = (NSMutableString *)[self.password stringByAppendingString:str];
    
    if (self.password.length == 6) {
        
        [self finalHandle];
        
    }
    
    

}

- (void)finalHandle{
    
    
    if (self.passwordInputType == PasswordInputTypeDefault) {
        

        [self passwordAuthNetworking];
        
        
    }else {
        
        
        
        if (self.password_one.length > 0) {
            

            if ([self.password_one isEqualToString:self.password]) {
                
                self.nextBtn.alpha = 1;

            }else{
                

                
                
                [[PopupAction defaultPopupAction] popupWithTitle:@"温馨提示" message:@"密码再次输入错误" ok:@"确定" cancel:nil okAction:^{
                    [self changeLabelTextWith:@"请设置支付密码，用于支付验证。"];
                    
                    self.password_one = nil;
                    [self resume];
                } cancelAction:nil of:self];
                
            }
            
            
        }else{
            
            [self changeLabelTextWith:@"请再次填写以确认"];
            self.password_one = [NSString stringWithString:self.password];
            [self resume];
        }
        
        
    }
    
    

    
    
}


- (void)changeLabelTextWith: (NSString *)string{
    
    CGRect frame = self.label.frame;
    
    CGRect changeFrame = frame;
    changeFrame.origin.x = - kRectWidth;

    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.label.frame = changeFrame;
        
    } completion:^(BOOL finished) {
        
        
        if (finished) {
            self.label.text = string;
            CGRect originFrame = frame;
            originFrame.origin.x = kRectWidth;
            self.label.frame = originFrame;
            
            [UIView animateWithDuration:0.2 animations:^{
                self.label.frame = frame;
            }];
        }
        
    }];
    
}


- (void)clearPassword: (NSString *)str{
    
//    UILabel *label = self.boxArray[self.password.length - 1];
//    label.text = @"";
    
    PointView *pointView = self.boxArray[self.password.length - 1];
    pointView.alpha = 0;
    
    self.password = (NSMutableString *)[self.password substringToIndex:self.password.length - 1];
    
    self.nextBtn.alpha = 0;
    

}

- (void)resume{
    
    for (PointView * pointView in self.boxArray) {
        pointView.alpha = 0;
    }
    
    self.password = nil;
    self.password = [NSMutableString string];
    
}


- (void)leftBtnAction{
    
    
    if (self.passwordInputType == PasswordInputTypeCompoundSetting || self.passwordInputType == PasswordInputTypeCompoundChange) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
    
}



- (void)sendValue:(PasswordBackValue)backValue{
    self.backValue = backValue;
}

#pragma mark ------------------------------ Networking -----------------------------------

- (void)networking{
    
}




#pragma mark ------------------------------ ParseData -----------------------------------

- (void)passwordAuthNetworking{
    
}

- (void)parseData: (NSData *)data{
  
}

- (void)parsePasswordAuthData: (NSData *)data{
    
    
}

@end
