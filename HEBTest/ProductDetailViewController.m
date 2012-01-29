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

@implementation ProductDetailViewController
@synthesize product=_product;
@synthesize nameLabel=_nameLabel, priceLabel=_priceLabel, descLabel=_descLabel, productImage=_productImage, expirationLabel=_expirationLabel;
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
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *shoppingListBarItem = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(showShoppingList)];
    self.navigationItem.rightBarButtonItem = shoppingListBarItem;
    [shoppingListBarItem release];
    self.nameLabel.text = self.product.name;
    self.nameLabel.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:14.0];
    self.nameLabel.textColor = [UIColor redColor];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.priceLabel.text = self.product.price;
    self.priceLabel.numberOfLines = 2;
    self.descLabel.text = self.product.desc;
    self.descLabel.numberOfLines = 0;
    self.descLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    self.expirationLabel.text = [NSString stringWithFormat:@"Expired on %@",self.product.eDate];
    
    if (self.flag == 1) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.addIntoListButton.hidden = YES;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.nameLabel = nil;
    self.priceLabel = nil;
    self.descLabel = nil;
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
