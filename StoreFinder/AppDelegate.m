//
//  AppDelegate.m
//  StoreFinder
//
//  Created by Mark Jones on 6/30/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//

#import "AppDelegate.h"

#import "FFAStoreListViewController.h"
#import "FFAWebViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[[FFAStoreListViewController alloc] initWithNibName:@"FFAStoreListViewController" bundle:nil] autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:viewController1] autorelease];
    [navController setTitle:@"TableView"];
    [navController.navigationBar setBarStyle:UIBarStyleBlack];
    
    UIViewController *viewController2 = [[[FFAWebViewController alloc] initWithNibName:@"FFAWebViewController" bundle:nil] autorelease];
    [viewController2 setTitle:@"WebView"];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navController, viewController2, nil];
    
    UITabBarItem *tab1 = [[[UITabBarItem alloc] initWithTitle:@"WebView" image:[UIImage imageNamed:@"rss.png"] tag:0] autorelease];
    [viewController2 setTabBarItem:tab1];
    UITabBarItem *tab2 = [[[UITabBarItem alloc] initWithTitle:@"TableView" image:[UIImage imageNamed:@"credit_card.png"] tag:1] autorelease];
    [navController setTabBarItem:tab2];

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
