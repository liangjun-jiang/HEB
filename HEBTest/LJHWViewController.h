//
//  LJHWViewController.h
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJHWViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *adsButton;
@property (strong, nonatomic) IBOutlet UIButton *couponButton;
@property (strong, nonatomic) IBOutlet UIButton *shoppingListButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutButton;

-(IBAction)adsTapped:(id)sender;
-(IBAction)couponTapped:(id)sender;
-(IBAction)listTapped:(id)sender;
-(IBAction)aboutTapped:(id)sender;

@end
