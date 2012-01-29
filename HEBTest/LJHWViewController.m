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
@synthesize adsButton=_adsButton, couponButton=_couponButton, shoppingListButton=_shoppingListButton, aboutButton=_aboutButton;

-(IBAction)adsTapped:(id)sender{
    LocationListViewController *locationListViewController = [[[LocationListViewController alloc] initWithNibName:@"LocationListViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:locationListViewController animated:YES];
}

-(IBAction)couponTapped:(id)sender
{
    
}
-(IBAction)listTapped:(id)sender
{
    ShoppingListViewController *shoppingListView = [[[ShoppingListViewController alloc] initWithNibName:@"ShoppingListViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:shoppingListView animated:YES];
}

-(IBAction)aboutTapped:(id)sender
{
    AboutListViewController *aboutView = [[[AboutListViewController alloc] initWithNibName:@"AboutListViewController" bundle:nil] autorelease];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.adsButton = nil;
    self.aboutButton= nil;
    self.shoppingListButton=nil;
    self.couponButton = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
