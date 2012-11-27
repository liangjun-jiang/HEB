//
//  LJHWAppDelegate.h
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJHWViewController;

@interface LJHWAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;

@property (strong, nonatomic) LJHWViewController *viewController;



@end
