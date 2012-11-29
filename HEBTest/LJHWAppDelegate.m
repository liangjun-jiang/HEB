//
//  LJHWAppDelegate.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import "LJHWAppDelegate.h"
#import "LocationListViewController.h"
#import "ProductListTableViewController.h"
#import "SettingsViewController.h"
#import "ProductCategoryViewController.h"
#import "SSTheme.h"
#import <CoreData/CoreData.h>

@interface LJHWAppDelegate()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation LJHWAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize locationManager;

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
    
    // Create location manager with filters set for battery efficiency.
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    UIViewController *viewController1, *viewController2, *viewController3;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if  ([defaults boolForKey:@"USE_DEFAULT_LOCATION"]){
        if ([defaults objectForKey:@"DEFAULT_HEB_ID"]) {
            viewController1 = [[ProductCategoryViewController alloc] initWithNibName:@"ProductCategoryViewController" bundle:nil];
            ((ProductCategoryViewController *)viewController1).storeId = [defaults objectForKey:@"DEFAULT_HEB_ID"];
            NSDictionary *heb = [defaults objectForKey:@"DEFAULT_HEB"];
            NSDictionary *geometry = heb[@"geometry"];
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([geometry[@"location"][@"lat"] doubleValue], [geometry[@"location"][@"lng"] doubleValue]);
            
//            NSLog(@"region this : %.3f, %.3f",location.latitude, location.longitude);
            CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:location radius:1000.0 identifier:heb[@"vicinity"]];
			[locationManager startMonitoringForRegion:newRegion desiredAccuracy:kCLLocationAccuracyBest];
            
        }
    }else {
        viewController1 = [[LocationListViewController alloc]
                       initWithNibName:@"LocationListViewController" bundle:nil];
        ((LocationListViewController*)viewController1).isSettingDefault = NO;
    }
    
    UINavigationController *navController1 = [[UINavigationController alloc]
                                              initWithRootViewController:viewController1];
    
    viewController2 = [[ProductListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    ((ProductListTableViewController*)viewController2).managedObjectContext = context;
    
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
    
    
    
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // This doesn't help clean up the badge shown
 	application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop significant location updates and start normal location updates again since the app is in the forefront.
		[self.locationManager stopMonitoringSignificantLocationChanges];
        
	}
	else {
		NSLog(@"Significant location change monitoring is not available.");
	}
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop normal location updates and start significant location change updates for battery efficiency.
        [self.locationManager startMonitoringSignificantLocationChanges];
	}
	else {
		NSLog(@"Significant location change monitoring is not available.");
	}
    
    
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

#pragma mark - Region Managerment

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region  {
	NSString *event = [NSString stringWithFormat:@"didEnterRegion %@ at %@", region.identifier, [NSDate date]];
	[self updateWithEvent:event];
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
	NSString *event = [NSString stringWithFormat:@"didExitRegion %@ at %@", region.identifier, [NSDate date]];
	
	[self updateWithEvent:event];
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
	NSString *event = [NSString stringWithFormat:@"monitoringDidFailForRegion %@: %@", region.identifier, error];
	[self updateWithEvent:event];
}

- (void)updateWithEvent:(NSString *)message {
    
    // Update the icon badge number.
	[UIApplication sharedApplication].applicationIconBadgeNumber++;

    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = message;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

@end
