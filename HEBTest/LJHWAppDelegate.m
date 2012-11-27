//
//  LJHWAppDelegate.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import "LJHWAppDelegate.h"
#import "LocationListViewController.h"
#import "ShoppingListViewController.h"
#import "SettingsViewController.h"
#import "ProductCategoryViewController.h"


@interface LJHWAppDelegate()

@end

@implementation LJHWAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *viewController1, *viewController2, *viewController3;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if  ([defaults boolForKey:@"USE_DEFAULT_LOCATION"]){
        if ([defaults objectForKey:@"DEFAULT_HEB_ID"]) {
            viewController1 = [[ProductCategoryViewController alloc] initWithNibName:@"ProductCategoryViewController" bundle:nil];
            ((ProductCategoryViewController *)viewController1).storeId = [defaults objectForKey:@"DEFAULT_HEB_ID"];
        }
    }else {
        viewController1 = [[LocationListViewController alloc]
                       initWithNibName:@"LocationListViewController" bundle:nil];
        ((LocationListViewController*)viewController1).isSettingDefault = NO;
    }
    
    UINavigationController *navController1 = [[UINavigationController alloc]
                                              initWithRootViewController:viewController1];
    
    viewController2 = [[ShoppingListViewController alloc]
                       initWithNibName:@"ShoppingListViewController" bundle:nil];
    UINavigationController *navController2 = [[UINavigationController alloc]
                                              initWithRootViewController:viewController2];
    
    viewController3 = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *navController3 = [[UINavigationController alloc]
                                              initWithRootViewController:viewController3];
    
    _tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[navController1, navController2, navController3];
    
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"Locations", @"")];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"List", @"")];
    
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:NSLocalizedString(@"Settings", @"")];

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
