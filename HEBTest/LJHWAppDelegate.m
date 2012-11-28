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
#import "SSTheme.h"
#import <CoreData/CoreData.h>

@interface LJHWAppDelegate()
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;


@end

@implementation LJHWAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSManagedObjectContext *context = [self managedObjectContext];
	if (!context) {
		// Handle the error.
		NSLog(@"Unresolved error (no context)");
		exit(-1);  // Fail
	}
    
    [SSThemeManager customizeAppAppearance];
    
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
    ((ShoppingListViewController*)viewController2).managedObjectContext = context;
    
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
    
    UITabBarItem *item1 = [navController1 tabBarItem];
    [SSThemeManager customizeTabBarItem:item1 forTab:SSThemeTabPower];
    
    UITabBarItem *item2 = [navController2 tabBarItem];
    [SSThemeManager customizeTabBarItem:item2 forTab:SSThemeTabDoor];
    
    UITabBarItem *item3 = [navController3 tabBarItem];
    [SSThemeManager customizeTabBarItem:item3 forTab:SSThemeTabControls];
    
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


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle the error.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        }
    }
}


#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender {
	
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
		// Handle the error.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Product.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		// Handle the error.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
