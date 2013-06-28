//
//  ProductCategoryViewController.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import "ProductCategoryViewController.h"
#import "ProductDetailViewController.h"
#import "ProductCategoryCell.h"
#import "ControlVariables.h"
#import "ProductCategoryCell_iphone.h"
#import "LJHWAppDelegate.h"
#import "Product.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"
#import "SSTheme.h"
#import "SVProgressHUD.h"
#import "NSDateFormatter+ThreadSafe.h"

#import "UITableViewCell+FlatUI.h"

#import "UIFont+FlatUI.h"
#import "UIColor+FlatUI.h"

#import "UINavigationBar+FlatUI.h"

@implementation ProductCategoryViewController
@synthesize storeId = _storeId;
@synthesize categories=_categories;
@synthesize reusableCells=_reusableCells;
@synthesize productList=_productList;
@synthesize queue=_queue, allEntries=_allEntries, feeds=_feeds;

- (void)refresh {
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
//    NSDateFormatter *formatter = [[NSDateFormatter dateW];
//    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",[[NSDateFormatter dateReader] stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    for (NSString *feed in _feeds) {
        NSURL *url = [NSURL URLWithString:feed];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [_queue addOperation:request];
    }
    
    // end
    [self.refreshControl endRefreshing];
}


-(NSMutableArray *)handleCategory:(NSString *)catString
{
    
    NSArray *seperated = [NSArray arrayWithArray:[catString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]]];
    NSMutableArray *reduced = [NSMutableArray array];
    for (NSString *str in seperated){
        if (![str isEqualToString:@""]) {
            [reduced addObject:str];
        }
    }
    
    return reduced;
}

-(void)updateTable
{
    [self.tableView reloadData];
    
}

#pragma mark - Pull to Refresh



#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if  (self){
        
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // this is from setting
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"USE_DEFAULT_LOCATION"]) {
        if ([defaults objectForKey:@"DEFAULT_HEB_ID"]){
            self.storeId = [defaults objectForKey:@"DEFAULT_HEB_ID"];
        }
  
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Items";
    
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeFont: [UIFont boldFlatFontOfSize:18]};
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    // add pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    // create a dummy product
    Product *product = [[Product alloc] initWithInfo:@"Wait a second ..." price:@"" image:@"" desc:@"" category:@"" psDate:@"" endingDate:@""];
    NSMutableArray *products = [NSMutableArray arrayWithObjects:product, nil];
    self.categories = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                       products, @"Baby",
                       products, @"Bakery", 
                       products, @"Beer, Wine & Spirits",
                       products, @"Combo Locos",
                       products, @"Cooking Utensils",
                       products, @"Dairy",
                       products, @"Deli",	 
                       products, @"Fish Market",	 
                       products, @"Floral",
                       products, @"Front Page",	 
                       products, @"Frozen",	 
                       products, @"General/Seasonal",
                       products, @"Grilling Accessories",	 
                       products, @"Grills",	 
                       products, @"Grocery",
                       products, @"Health and Beauty", 
                       products, @"Household",	 
                       products, @"Meal Deal",
                       products, @"Meat Market",	 
                       products, @"Pets",	 
                       products, @"Pharmacy",
                       products, @"Produce",
                       nil];
    
    [self.tableView setBackgroundColor:kVerticalTableBackgroundColor];
    self.tableView.rowHeight = kCellHeight + (kRowVerticalPadding * 0.5) + (kRowVerticalPadding * 0.5 * 0.5);
    
    self.allEntries = [NSMutableArray array];
    self.queue = [[NSOperationQueue alloc] init];
    self.feeds = @[[NSString stringWithFormat:@"http://heb.inserts2online.com/rss.jsp?drpStoreID=%@&categories=all",self.storeId]]; 
    [self refresh];
    
    if (!self.reusableCells) {
        
        self.reusableCells = [NSMutableArray array];
        
        for (int i = 0; i < [self.categories.allKeys count]; i++)
        {                        
            ProductCategoryCell_iphone *cell = [[ProductCategoryCell_iphone alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
            NSSortDescriptor *sortDescriptor= [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
            NSArray* sortedCategories = [self.categories.allKeys sortedArrayUsingDescriptors:@[sortDescriptor]];
            NSString* categoryName = sortedCategories[i];
            NSArray* currentCategory = (self.categories)[categoryName];
            cell.products = [NSArray arrayWithArray:currentCategory];
            
            [self.reusableCells addObject:cell];
        }
      
    }
     
    [self performSelector:@selector(updateTable) withObject:nil afterDelay:5];
}


- (void)parseRss:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    NSArray *channels = [rootElement elementsForName:@"channel"];
    for (GDataXMLElement *channel in channels) {            
        
        NSArray *items = [channel elementsForName:@"item"];
        for (GDataXMLElement *item in items) {
            NSString *name = [item valueForChild:@"title"];
            NSString *price = [item valueForChild:@"vertis:price"];
            NSString *imgUrl = [item valueForChild:@"vertis:itemimage"];
            NSString *descStr = [item valueForChild:@"vertis:description"];
            NSString *dateString = [item valueForChild:@"vertis:psdate"];
            NSString *eString = [item valueForChild:@"vertis:edate"];
            NSString *categories = [item valueForChild:@"vertis:category2"];
            
            Product *product = [[Product alloc] initWithInfo:name price:price image:imgUrl desc:descStr category:[categories stringByReplacingOccurrencesOfString:@"~~" withString:@","] psDate:dateString endingDate:eString]; 
            
            [entries addObject:product];   
            
        }      
    }
    
}

- (void)parseFeed:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {    
    if ([rootElement.name compare:@"rss"] == NSOrderedSame) {
        [self parseRss:rootElement entries:entries];
    } else {
        NSLog(@"Unsupported root element: %@", rootElement.name);
    }    
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    
    [_queue addOperationWithBlock:^{
        
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[request responseData] 
                                                               options:0 error:&error];
        if (doc == nil) { 
            NSLog(@"Failed to parse %@", request.url);
        } else {
            NSMutableArray *entries = [NSMutableArray array];
            [self parseFeed:doc.rootElement entries:entries]; 
            //Probablly there is a better way to do this ...
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                NSMutableArray *babyArray=[NSMutableArray array];
                NSMutableArray *bakeryArray=[NSMutableArray array];
                NSMutableArray *beerArray=[NSMutableArray array];
                NSMutableArray *comboArray=[NSMutableArray array];
                NSMutableArray *cookingArray=[NSMutableArray array];
                NSMutableArray *dairyArray=[NSMutableArray array];
                NSMutableArray *deliArray=[NSMutableArray array];
                NSMutableArray *fishArray=[NSMutableArray array];
                NSMutableArray *floralArray=[NSMutableArray array];
                NSMutableArray *frontPageArray=[NSMutableArray array];
                NSMutableArray *frozenArray=[NSMutableArray array];
                NSMutableArray *generalArray=[NSMutableArray array];
                NSMutableArray *grillingAccessoriesArray=[NSMutableArray array];
                NSMutableArray *grillsArray=[NSMutableArray array];
                NSMutableArray *groceryArray=[NSMutableArray array];
                NSMutableArray *healthArray=[NSMutableArray array];
                NSMutableArray *householdArray=[NSMutableArray array];
                NSMutableArray *mealArray=[NSMutableArray array];
                NSMutableArray *meatArray=[NSMutableArray array];
                NSMutableArray *petsArray=[NSMutableArray array];
                NSMutableArray *pharmacyArray=[NSMutableArray array];
                NSMutableArray *produceArray=[NSMutableArray array];
                
                for (Product *product in entries) {
                    for (NSString *category in [self handleCategory:product.category]) {
                        if ([category isEqualToString:@"Baby"]) {
                            [babyArray addObject:product];
                        } else if ([category isEqualToString:@"Bakery"]){
                            [bakeryArray addObject:product];
                        } else if ([category isEqualToString:@"Beer, Wine & Spirits"]){
                            [beerArray addObject:product];
                        } else if ([category isEqualToString:@"Combo Locos"]){
                            [comboArray addObject:product];
                        } else if ([category isEqualToString:@"Cooking Utensils"]){
                            [cookingArray addObject:product];
                        } else if ([category isEqualToString:@"Dairy"]){
                            [dairyArray addObject:product];
                        } else if ([category isEqualToString:@"Deli"]){
                            [deliArray addObject:product];
                        } else if ([category isEqualToString:@"Fish Market"]){
                            [fishArray addObject:product];
                        } else if ([category isEqualToString:@"Floral"]){
                            [floralArray addObject:product];
                        } else if ([category isEqualToString:@"Frozen"]){
                            [frozenArray addObject:product];
                        } else if ([category isEqualToString:@"General/Seasonal"]){
                            [generalArray addObject:product];
                        } else if ([category isEqualToString:@"Grilling Accessories"]){
                            [grillingAccessoriesArray addObject:product];
                        } else if ([category isEqualToString:@"Grills"]){
                            [grillsArray addObject:product];
                        } else if ([category isEqualToString:@"Grocery"]){
                            [groceryArray addObject:product];
                        } else if ([category isEqualToString:@"Health and Beauty"]){
                            [healthArray addObject:product];
                        } else if ([category isEqualToString:@"Household"]){
                            [householdArray addObject:product];
                        } else if ([category isEqualToString:@"Meal Deal"]){
                            [mealArray addObject:product];
                        } else if ([category isEqualToString:@"Meat Market"]){
                            [meatArray addObject:product];
                        } else if ([category isEqualToString:@"Pets"]){
                            [petsArray addObject:product];
                        } else if ([category isEqualToString:@"Pharmacy"]){
                            [pharmacyArray addObject:product];
                        } else if ([category isEqualToString:@"Produce"]){
                            [produceArray addObject:product]; 
                        } else if ([category isEqualToString:@"Front Page"]){
                            [frontPageArray addObject:product];
                        }
                        
                    }
                }
               
                (self.categories)[@"Baby"] = babyArray;
                (self.categories)[@"Bakery"] = bakeryArray;
                (self.categories)[@"Beer, Wine & Spirits"] = beerArray;
                (self.categories)[@"Combo Locos"] = comboArray;
                (self.categories)[@"Cooking Utensils"] = cookingArray;
                (self.categories)[@"Dairy"] = dairyArray;
                (self.categories)[@"Deli"] = deliArray;
                (self.categories)[@"Fish Market"] = fishArray;
                (self.categories)[@"Floral"] = floralArray;
                (self.categories)[@"Frozen"] = frozenArray;
                (self.categories)[@"General/Seasonal"] = generalArray;
                (self.categories)[@"Grilling Accessories"] = grillingAccessoriesArray;
                (self.categories)[@"Grills"] = grillsArray;
                (self.categories)[@"Grocery"] = groceryArray;
                (self.categories)[@"Health and Beauty"] = healthArray;
                (self.categories)[@"Household"] = householdArray;
                (self.categories)[@"Meal Deal"] = mealArray;
                (self.categories)[@"Meat Market"] = meatArray;
                (self.categories)[@"Pets"] = petsArray;
                (self.categories)[@"Pharmacy"] = pharmacyArray;
                (self.categories)[@"Produce"] = produceArray;
                (self.categories)[@"Front Page"] = frontPageArray;
                
                self.reusableCells = [NSMutableArray array];
                
                for (int i = 0; i < [self.categories.allKeys count]; i++)
                {                        
                    ProductCategoryCell_iphone *cell = [[ProductCategoryCell_iphone alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
                    
                    NSSortDescriptor *sortDescriptor= [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                    NSArray* sortedCategories = [self.categories.allKeys sortedArrayUsingDescriptors:@[sortDescriptor]];
                    NSString* categoryName = sortedCategories[i];
                    NSArray* currentCategory = (self.categories)[categoryName];
                    cell.products = [NSArray arrayWithArray:currentCategory];
                    [self.reusableCells addObject:cell];
                }
                
                
            }];
        }        
    }];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.storeId = nil;
    self.reusableCells = nil;
    self.productList = nil;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 21;
    return [self.categories.allKeys count];
}

#define kHeadlineSectionHeight 18
#define kRegularSectionHeight 18

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? kHeadlineSectionHeight:kRegularSectionHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customSectionHeaderView;
    UILabel *titleLabel;
    UIFont *labelFont;
    
    if (section ==0) {
        customSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kHeadlineSectionHeight)];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, kHeadlineSectionHeight)];
        labelFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:16.0];;
    } else {
        customSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kRegularSectionHeight)];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, kRegularSectionHeight)];
        labelFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:14.0];;   
    }
    customSectionHeaderView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.95];
    
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel setTextColor:[UIColor redColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.font = labelFont;
    
    NSSortDescriptor *sortDescriptor= [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
    NSArray* sortedCategories = [self.categories.allKeys sortedArrayUsingDescriptors:@[sortDescriptor]];
    NSString *categoryName = sortedCategories[section];
    
    titleLabel.text = categoryName;
    
    [customSectionHeaderView addSubview:titleLabel];

    return customSectionHeaderView;
      
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCategoryCell *cell = (self.reusableCells)[indexPath.section];
    [cell setNeedsLayout];
    return cell;
}


@end
