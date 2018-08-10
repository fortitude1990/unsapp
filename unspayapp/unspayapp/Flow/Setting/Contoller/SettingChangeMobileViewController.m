//
//  SettingChangeMobileViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/8/10.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "SettingChangeMobileViewController.h"

@interface SettingChangeMobileViewController ()
@property (strong, nonatomic) IBOutlet UIView *oneItem;
@property (strong, nonatomic) IBOutlet UIView *twoItem;

@end

@implementation SettingChangeMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

- (void)createUI{
    
    self.navigationItem.title = @"换绑手机";
    
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapAction)];
    [self.oneItem addGestureRecognizer:tapGes];
    
    UITapGestureRecognizer *twoTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTapAction)];
    [self.twoItem addGestureRecognizer:twoTapGes];
    
}

- (void)oneTapAction{
    
    
    
}

- (void)twoTapAction{
    
}

@end
