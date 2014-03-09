//
//  AboutListViewController.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/16/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
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


#pragma mark - View lifecycle

- (void)viewDidLoad
{
   
    self.title = @"About";
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 150.0)];
    imgView.image = [UIImage imageNamed:@"fruit_basket.png"];
    [self.view addSubview:imgView];
 
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 40.0, 300, 310)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = @"H-E-B Grocery Stores (H-E-B) is a privately held San Antonio, Texas-based supermarket chain with more than 315 stores throughout Texas and northern Mexico.  This app provides an easy way to browse the weekly ads, deals and coupon of your nearby H-E-B stores. You can also add the product item into your shipping list, with the friendly shopping list, you can save more.";
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;// UILineBreakModeWordWrap;
    textLabel.textAlignment = NSTextAlignmentRight;
    textLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:textLabel];
    UILabel *textLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 350.0, 300, 60)];
    textLabel2.backgroundColor = [UIColor clearColor];
    textLabel2.text = @"This app is created by LJSport Apps Ltd, not affiliated with the H-E-B.";
    textLabel2.numberOfLines = 0;
    textLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel2.textAlignment = NSTextAlignmentRight;
    textLabel2.font = [UIFont systemFontOfSize:14.0];
    
    [self.view addSubview:textLabel2];
    [super viewDidLoad];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
