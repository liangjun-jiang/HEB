//
//  ProductDetailViewController.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ShoppingListViewController.h"
#import "Product.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, 
                                                         YES);
    NSString *path = [paths[0] stringByAppendingPathComponent:@"Products.plist"];
    NSMutableArray *productDicts = [NSMutableArray arrayWithContentsOfFile:path];
    [productDicts addObject:[self.product dictionaryWithValuesForKeys:[Product keys]]];
    NSString *plist = [productDicts description];
    NSError *error = nil;
 
    [plist writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"Something wrong"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"Success."];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIBarButtonItem *shoppingListBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addIntoList:)];
    self.navigationItem.rightBarButtonItem = shoppingListBarItem;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 5, 271, 30)];
    nameLabel.text = self.product.name;
    nameLabel.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:14.0];
    nameLabel.textColor = [UIColor blueColor];
    nameLabel.numberOfLines = 0;
    nameLabel.lineBreakMode = UILineBreakModeWordWrap;
    [self.view addSubview:nameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 35, 271, 15)];
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
    
    if (self.flag == 1) {
        self.navigationItem.rightBarButtonItem = nil;
       
    }
    
    [self.productImage setImageWithURL:[NSURL URLWithString:self.product.imgLink] placeholderImage:nil];
    
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
