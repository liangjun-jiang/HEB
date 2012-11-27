//
//  LJHWViewController.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//


#import "LJHWViewController.h"
#import "LocationListViewController.h"
#import "ShoppingListViewController.h"
#import "AboutListViewController.h"

@implementation LJHWViewController
@synthesize adsButton=_adsButton, shoppingListButton=_shoppingListButton, aboutButton=_aboutButton;

-(IBAction)adsTapped:(id)sender{
    LocationListViewController *locationListViewController = [[LocationListViewController alloc] initWithNibName:@"LocationListViewController" bundle:nil];
    [self.navigationController pushViewController:locationListViewController animated:YES];
}

-(IBAction)couponTapped:(id)sender
{
    
}
-(IBAction)listTapped:(id)sender
{
    ShoppingListViewController *shoppingListView = [[ShoppingListViewController alloc] initWithNibName:@"ShoppingListViewController" bundle:nil];
    [self.navigationController pushViewController:shoppingListView animated:YES];
}

-(IBAction)aboutTapped:(id)sender
{
    AboutListViewController *aboutView = [[AboutListViewController alloc] initWithNibName:@"AboutListViewController" bundle:nil];
    [self.navigationController pushViewController:aboutView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"H-E-B Weekly Ads";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 200.0)];
    imgView.image = [UIImage imageNamed:@"fruit_basket.png"];
    [self.view addSubview:imgView];
    
    UILabel *adLabel = [[UILabel alloc] initWithFrame:CGRectMake(238, 109, 80, 30)];
    adLabel.text = @"ADs";
    adLabel.backgroundColor = [UIColor clearColor];
    adLabel.font = [UIFont fontWithName:@"Chalkduster" size:25];
    adLabel.textColor = [UIColor redColor];
    [self.view addSubview:adLabel];
    
    UILabel *listLabel = [[UILabel alloc] initWithFrame:CGRectMake(209, 263, 120, 30)];
    listLabel.backgroundColor = [UIColor clearColor];
    listLabel.text = @"List";
    listLabel.font = [UIFont fontWithName:@"Chalkduster" size:25];
    listLabel.textColor = [UIColor redColor];
    [self.view addSubview:listLabel];
    
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(43,365, 120, 30)];
    aboutLabel.backgroundColor = [UIColor clearColor];
    aboutLabel.text = @"About";
    aboutLabel.font = [UIFont fontWithName:@"Chalkduster" size:25];
    aboutLabel.textColor = [UIColor redColor];
    [self.view addSubview:aboutLabel];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.adsButton = nil;
    self.aboutButton= nil;
    self.shoppingListButton=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
