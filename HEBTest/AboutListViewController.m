//
//  AboutListViewController.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/16/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import "AboutListViewController.h"

@implementation AboutListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
   
    self.title = @"About";
    
    UIImageView *imgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 150.0)] autorelease];
    imgView.image = [UIImage imageNamed:@"fruit_basket.png"];
    [self.view addSubview:imgView];
 
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 40.0, 310, 310)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = @"H-E-B Grocery Stores (H-E-B) is a privately held San Antonio, Texas-based supermarket chain with more than 315 stores throughout Texas and northern Mexico.  This app provides an easy way to browse the weekly ads, deals and coupon from your nearby H-E-B stores. You can also add the product item into your shipping list, with the friendly shopping list, you can save more. ";
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = UILineBreakModeWordWrap;
    textLabel.textAlignment = UITextAlignmentRight;
    textLabel.font = [UIFont fontWithName:@"Chalkduster" size:16];
    [self.view addSubview:textLabel];
    [textLabel release];
    UILabel *textLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 350.0, 310, 60)];
    textLabel2.backgroundColor = [UIColor clearColor];
    textLabel2.textColor = [UIColor redColor];
    textLabel2.text = @"This app is created by LJSport Apps Ltd, not affiliated with the H-E-B.";
    textLabel2.numberOfLines = 0;
    textLabel2.lineBreakMode = UILineBreakModeWordWrap;
    textLabel2.textAlignment = UITextAlignmentRight;
    textLabel2.font = [UIFont fontWithName:@"Chalkduster" size:16];
    
    [self.view addSubview:textLabel2];
    [textLabel2 release];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
