//
//  ProductDetailViewController.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "Product.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "SavedProduct.h"
#import "LJHWAppDelegate.h"

@implementation ProductDetailViewController
@synthesize product=_product;
@synthesize productImage=_productImage;//, expirationLabel=_expirationLabel;
@synthesize flag=_flag;

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

-(void)addIntoList:(id)sender
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = ((LJHWAppDelegate*)appDelegate).managedObjectContext;
    
    SavedProduct *savedProduct = [NSEntityDescription insertNewObjectForEntityForName:@"SavedProduct" inManagedObjectContext:context];
    
    // I know this is silly. I just don't want to spend any effort on Product Category page
    savedProduct.name = self.product.name;
    savedProduct.desc = self.product.desc;
    savedProduct.eDate = self.product.eDate;
    savedProduct.price = self.product.price;
    savedProduct.category = self.product.category;
    savedProduct.psDate = self.product.psDate;
    savedProduct.imgLink = self.product.imgLink;
    
	NSError *error = nil;
	if (![savedProduct.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
        [SVProgressHUD showErrorWithStatus:@"Something wrong"];
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	} else
    {
        [SVProgressHUD showSuccessWithStatus:@"Success."];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Product Detail";
    
//    UIBarButtonItem *shoppingListBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addIntoList:)];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addIntoList:)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 5, 271, 30)];
    nameLabel.text = self.product.name;
    nameLabel.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:14.0];
    nameLabel.textColor = [UIColor blueColor];
    nameLabel.numberOfLines = 0;
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:nameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 35, 271, 15)];
    priceLabel.text = self.product.price;
    priceLabel.font = [UIFont fontWithName:@"Baskerville-Bold" size:14];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.numberOfLines = 0;
    priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:priceLabel];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 68, 271, 35)];
    descLabel.numberOfLines = 0;
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descLabel.text = self.product.desc;
    descLabel.font = [UIFont fontWithName:@"ArialHebrew" size:10];
    [self.view addSubview:descLabel];
    
    if (self.flag == 1) {
        self.navigationItem.rightBarButtonItem = nil;
       
    }
//    NSLog(@"the link :%@",self.product.imgLink);
    
    NSString *largeImageLink = [self.product.imgLink stringByReplacingOccurrencesOfString:@"small"
                                                                               withString:@"large"];
    [self.productImage setImageWithURL:[NSURL URLWithString:largeImageLink] placeholderImage:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.productImage = nil;
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
