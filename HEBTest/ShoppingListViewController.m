//
//  ShoppingListViewController.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "Product.h"
#import "ProductDetailViewController.h"
#import "UIImage+Resizing.h"

@implementation ShoppingListViewController
@synthesize selectedProducts=_selectedProducts;


+(NSString *)pathForDocumentsWithName:(NSString *)documentName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    
    return [path stringByAppendingPathComponent:documentName];
}

-(NSMutableArray *)displayedSelectProducts
{
    if (_selectedProducts == nil) {
        NSString *path = [[self class] pathForDocumentsWithName:@"Products.plist"];
        NSArray *productDicts = [NSMutableArray arrayWithContentsOfFile:path];
        if (productDicts == nil) {
            NSLog(@"can't read path: %@", path);
            path = [[NSBundle mainBundle] pathForResource:@"Products" ofType:@"plist"];
            productDicts = [NSMutableArray arrayWithContentsOfFile:path];
        }
        _selectedProducts = [[NSMutableArray alloc] initWithCapacity:[productDicts count]];
        
        if ([productDicts isKindOfClass:[NSArray class]]) {
            for (NSDictionary *currDict in productDicts)
            {
                if ([currDict isKindOfClass:[NSDictionary class]]) {
                    Product *product = [[Product alloc] initWithDictionary:currDict];
                    [_selectedProducts addObject:product];
                    
                }
            }

        }
    }
    return _selectedProducts;
}

-(void)addObject:(id)anObject
{
    if (anObject == nil) {
        [[self displayedSelectProducts] addObject:anObject];
    }
}

-(void)save
{
    NSMutableArray *productDicts = [NSMutableArray arrayWithCapacity:[[self displayedSelectProducts] count]];
    
    // Convert the array of products into an array of dictionaries for storage
    
    for (id currObj in [self displayedSelectProducts]) {
        [productDicts addObject:[currObj dictionaryWithValuesForKeys:[Product keys]]];
    }
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
    NSUserDomainMask, 
    YES);
    NSString *path = [paths[0] stringByAppendingPathComponent:@"Products.plist"];

    NSString *plist = [productDicts description];
    NSError *error = nil;
    [plist writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error writting file at path: %@; error was %@", path, error);
    }

}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    _selectedProducts = nil;
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Shopping List";
    self.clearsSelectionOnViewWillAppear = NO;
 
    // We don't allow the use to add 
    //UIBarButtonItem *addItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)] autorelease];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setRowHeight:62.0];
    
    [self displayedSelectProducts];
    
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    UIBarButtonItem *editButton = [self.navigationItem rightBarButtonItem];
    [editButton setEnabled:!editing];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self save];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([_selectedProducts count] == 0) {
        return 1;
    }
    return [_selectedProducts count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
        UIFont *titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:14.0];
        cell.textLabel.font = titleFont;
        UIFont *detailFont = [UIFont fontWithName:@"Georgia" size:11.0];
        cell.detailTextLabel.font = detailFont;
        
    }
    __weak Product *product = [self selectedProducts ][indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.text = (product.name == nil)?@"":product.name;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, before %@",product.price, product.eDate];
    UIImage *holderImage = [UIImage imageNamed:@"NoImage"];
    cell.imageView.image = [holderImage imageScaledToSize:CGSizeMake(42.0, 49.0)];
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{        
        UIImage *image = nil;
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:product.imgLink]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = [image imageScaledToSize:CGSizeMake(42.0, 49.0)];
        });
    }); 
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[self displayedSelectProducts] removeObjectAtIndex:indexPath.row];
         
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if (fromIndexPath.row != toIndexPath.row) {
        [[self displayedSelectProducts] exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     ProductDetailViewController *detailViewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    
    detailViewController.product = _selectedProducts[indexPath.row];
    detailViewController.flag = 1;
    detailViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self.navigationController presentModalViewController:detailViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     
}

@end
