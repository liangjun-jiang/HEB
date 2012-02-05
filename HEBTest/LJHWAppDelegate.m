//
//  LJHWAppDelegate.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import "LJHWAppDelegate.h"
#import "LJHWViewController.h"

@implementation LJHWAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navController = _navController;
- (void)dealloc
{
    
    [_window release];
    [_navController release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.viewController = [[[LJHWViewController alloc] initWithNibName:@"LJHWViewController" bundle:nil] autorelease];
    
    self.navController = [[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
    [self.navController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Chalkduster" size:18],UITextAttributeFont, nil]]; 
    self.navController.navigationBar.tintColor = [UIColor colorWithRed:0.988235294 green:0.0666666667 blue:0.0196078431 alpha:1.0];
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
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
