//
//  XSTabBarController.m
//  douyu01
//
//  Created by xiaos on 15/11/17.
//  Copyright © 2015年 com.xsdota. All rights reserved.
//

#import "XSTabBarController.h"
#import "XSNavigationController.h"

#import "XSHomeViewController.h"

#import "XSMineViewController.h"
#import "XSMineController.h"

//#import "public.h"

@interface XSTabBarController ()

@end

@implementation XSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 设置tabbar背景色 */
    UIView *backView         = [[UIView alloc]initWithFrame:self.view.frame];
    backView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:backView atIndex:0];
//    self.tabBar.opaque=YES;
    
    /** 设置tabbar高亮色 */
    self.tabBar.tintColor= BASE_COLOR;
    
    /** 初始化子控制器 */
    [self setUpChildController];
    
}

- (void)setUpChildController
{
    XSHomeViewController *home = [XSHomeViewController new];
    [self setUpController:home image:[UIImage imageNamed:@"tabbar_mainframe"] selImage:nil title:@"首页"];
    
    XSMineController *me = [XSMineController new];
    [self setUpController:me image:[UIImage imageNamed:@"tabbar_me"] selImage:nil title:@"我"];

    
    
//    XSMineViewController *mine = [XSMineViewController new];
//    [self setUpController:mine image:[UIImage imageNamed:@"tabbar_me"] selImage:nil title:@"我"];
    
}

- (void)setUpController:(UIViewController *)vc image:(UIImage *)image selImage:(UIImage *)selImage title:(NSString *)title
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = image;
    if (selImage) {
        vc.tabBarItem.selectedImage = selImage;
    }
    XSNavigationController *navi = [[XSNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:navi];
}


@end
