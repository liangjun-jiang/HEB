//
//  LJHWAppDelegate.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import "LJHWAppDelegate.h"
#import "LJHWViewController.h"
#import "ShoppingListViewController.h"
#import "AboutListViewController.h"

@interface LJHWAppDelegate()
@property (nonatomic, strong) UITabBarController *tabBarController;
@end

@implementation LJHWAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navController = _navController;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *viewController1, *viewController2, *viewController3;
    
    viewController1 = [[LJHWViewController alloc]
                       initWithNibName:@"LJHWViewController" bundle:nil];
    UINavigationController *navController1 = [[UINavigationController alloc]
                                              initWithRootViewController:viewController1];
    
    viewController2 = [[ShoppingListViewController alloc]
                       initWithNibName:@"ShoppingListViewController" bundle:nil];
    UINavigationController *navController2 = [[UINavigationController alloc]
                                              initWithRootViewController:viewController2];
    
    viewController3 = [[AboutListViewController alloc] initWithNibName:@"AboutListViewController" bundle:nil];
    UINavigationController *navController3 = [[UINavigationController alloc]
                                              initWithRootViewController:viewController3];
    
    _tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[navController1, navController2, navController3];
    self.window.rootViewController = self.tabBarController;

    [self.window makeKeyAndVisible];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
  	NSString *storePath = [basePath stringByAppendingPathComponent: @"Products.plist"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected file doesn't exist, copy the default file.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Products" ofType:@"plist"];
		if (defaultStorePath) {
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   
}




@end
