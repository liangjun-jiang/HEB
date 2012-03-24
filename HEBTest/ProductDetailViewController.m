//
//  ProductDetailViewController.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ShoppingListViewController.h"
#import "Product.h"
#import "UIBezierPath+ShadowPath.h"

@implementation ProductDetailViewController
@synthesize product=_product;
@synthesize productImage=_productImage, expirationLabel=_expirationLabel;
@synthesize spinner=_spinner, addIntoListButton=_addIntoListButton;
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
-(void)showShoppingList{
    ShoppingListViewController *shoppingListView = [[ShoppingListViewController alloc] init];
    shoppingListView.modalTransitionStyle= UIModalTransitionStylePartialCurl;
    [self.navigationController presentModalViewController:shoppingListView animated:YES];
    [shoppingListView release];
    
}


-(IBAction)addIntoList
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, 
                                                         YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Products.plist"];
    NSMutableArray *productDicts = [NSMutableArray arrayWithContentsOfFile:path];
    [productDicts addObject:[self.product dictionaryWithValuesForKeys:[Product keys]]];
    NSString *plist = [productDicts description];
    NSError *error = nil;
 
    [plist writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"Error writting file at path: %@; error was %@", path, error);
    }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Confirmed"
                                                      message:@"Item added."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    [message release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *shoppingListBarItem = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(showShoppingList)];
    self.navigationItem.rightBarButtonItem = shoppingListBarItem;
    [shoppingListBarItem release];
    UILabel *nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(23, 5, 271, 30)] autorelease];
    nameLabel.text = self.product.name;
    nameLabel.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:14.0];
    nameLabel.textColor = [UIColor blueColor];
    nameLabel.numberOfLines = 0;
    nameLabel.lineBreakMode = UILineBreakModeWordWrap;
    [self.view addSubview:nameLabel];
    
    UILabel *priceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(23, 35, 271, 15)] autorelease];
    priceLabel.text = self.product.price;
    priceLabel.font = [UIFont fontWithName:@"Baskerville-Bold" size:14];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.numberOfLines = 0;
    priceLabel.lineBreakMode = UILineBreakModeWordWrap;
    [self.view addSubview:priceLabel];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 68, 271, 35)];
    descLabel.numberOfLines = 0;
    descLabel.lineBreakMode = UILineBreakModeWordWrap;
    descLabel.text = self.product.desc;
    descLabel.font = [UIFont fontWithName:@"ArialHebrew" size:10];
    [self.view addSubview:descLabel];
    [descLabel release];
    
    if (self.flag == 1) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.addIntoListButton.hidden = YES;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.productImage = nil;
    self.spinner = nil;
    self.addIntoListButton = nil;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.spinner startAnimating];
    [self.product processImageDataWithBlock:^(NSData *imageData){
        if (self.view.window) {
			UIImage *image = [UIImage imageWithData:imageData];
			self.productImage.image = image;
			[self.spinner stopAnimating];
            [self.view bringSubviewToFront:self.productImage];
       }
	}];
     
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
