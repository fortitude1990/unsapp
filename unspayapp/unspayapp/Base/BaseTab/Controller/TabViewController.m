//
//  TabViewController.m
//  UNS5
//
//  Created by 李志敬 on 2018/7/3.
//  Copyright © 2018年 MaChenxi. All rights reserved.
//

#import "TabViewController.h"
#import "TabView.h"
#import "TabItemModel.h"
#import "HomePageViewController.h"
#import "PersonCenterViewController.h"
#import "BaseNavController.h"

@interface TabViewController ()

{
    dispatch_semaphore_t _semaphore;
}

@property (nonatomic, strong)TabView *tabView;

@end

@implementation TabViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createSubViews];
    [self createTabBar];

    _semaphore = dispatch_semaphore_create(1);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{


    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{

    return [self.selectedViewController preferredInterfaceOrientationForPresentation];

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

- (void)createTabBar{
    
    
    
    TabView *tabView = [[TabView alloc] initWithFrame:CGRectMake(0, kRectHeight - 50, kRectWidth, 50)];
    [self.view addSubview:tabView];
    
    [tabView didSelect:^(NSInteger index) {
        self.selectedIndex = index;
    }];
    
    TabItemModel *oneItem = [[TabItemModel alloc] init];
    oneItem.highlightImageName = @"首页-选中";
    oneItem.normalImageName = @"首页";
    oneItem.title = @"首页";
    
    TabItemModel *twoItem = [[TabItemModel alloc] init];
    twoItem.highlightImageName = @"个人中心-选中";
    twoItem.normalImageName = @"个人中心";
    twoItem.title = @"个人中心";
    
    
    tabView.items = @[oneItem, twoItem];
    
    self.tabView = tabView;
    
    [self.tabBar addObserver:self forKeyPath:@"hidden" options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld ) context:nil];
    
    self.tabBar.hidden = YES;

    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (self.tabBar.hidden == NO) {
        self.tabBar.hidden = YES;
    }
    
}


- (void)setHiddenTabView:(BOOL)hiddenTabView{
    
    if (self.tabBar.hidden == NO) {
        self.tabBar.hidden = YES;
    }
    
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    
    if (hiddenTabView) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect react = self.tabView.frame;
            react.origin.y = kRectHeight;
            self.tabView.frame = react;
            
        }];
        
    }
    
    if (!hiddenTabView) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect react = self.tabView.frame;
            react.origin.y = kRectHeight - 50;
            self.tabView.frame = react;
            
        }];
        
    }
    
    _hiddenTabView = YES;

    dispatch_semaphore_signal(_semaphore);
}

- (void)createSubViews{
    
    HomePageViewController *appCenterVC = [[HomePageViewController alloc] init];
    BaseNavController *appCenterNavC = [[BaseNavController alloc] initWithRootViewController:appCenterVC];
    
    PersonCenterViewController *userCenterVC = [[PersonCenterViewController alloc] init];
    BaseNavController *userCenterNavC = [[BaseNavController alloc] initWithRootViewController:userCenterVC];
    
    self.viewControllers = @[appCenterNavC,userCenterNavC];
    
}


@end
