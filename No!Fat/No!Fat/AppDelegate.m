//
//  AppDelegate.m
//  No!Fat
//
//  Created by 莫大宝 on 16/4/19.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "AppDelegate.h"
#import "SelectionViewController.h"
#import "TrainTableViewController.h"
#import "PersonCenterViewController.h"
#import "NewsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    TrainTableViewController *trainTableVC = [[TrainTableViewController alloc] init];
    UITabBarItem *trainItem = [[UITabBarItem alloc] initWithTitle:@"训练" image:[[UIImage imageNamed:@"trainGary"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"trainBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    trainTableVC.tabBarItem = trainItem;
    UINavigationController *trainNaVC = [[UINavigationController alloc] initWithRootViewController:trainTableVC];
    
//    SelectionViewController *seletionVC = [[SelectionViewController alloc] init];
//    UITabBarItem *selectionItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[[UIImage imageNamed:@"findGary"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"findBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    seletionVC.tabBarItem = selectionItem;
//    UINavigationController *selectionNaVC = [[UINavigationController alloc] initWithRootViewController:seletionVC];
    
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    UITabBarItem *newsItem = [[UITabBarItem alloc] initWithTitle:@"动态" image:[[UIImage imageNamed:@"newsGary"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"newsBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    newsVC.tabBarItem = newsItem;
    UINavigationController *newsNaVC = [[UINavigationController alloc] initWithRootViewController:newsVC];
    
    PersonCenterViewController *personVC = [[PersonCenterViewController alloc] init];
    UITabBarItem *personItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[[UIImage imageNamed:@"personCenterGary"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"personCenterBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    personVC.tabBarItem = personItem;
    UINavigationController *personNaVC = [[UINavigationController alloc] initWithRootViewController:personVC];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    // 设置标签视图控制器需要管理的子视图控制器
    tabBarController.viewControllers = @[trainNaVC, newsNaVC, personNaVC];
    // 设定标签栏选中的标签下标
    tabBarController.selectedIndex = 0;
    tabBarController.tabBar.tintColor = [UIColor blackColor];
    
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
