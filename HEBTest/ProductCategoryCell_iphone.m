//
//  ProductCategoryCell_iphone.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import "ProductCategoryCell_iphone.h"
#import "ControlVariables.h"
#import "ProductCell.h"
#import "ProductNameLabel.h"
#import "ProductDetailViewController.h"
#import "LJHWAppDelegate.h"
#import "Product.h"


@implementation ProductCategoryCell_iphone

-(id)initWithFrame:(CGRect)frame
{
    if ((self=[super initWithFrame:frame]))
    {
        self.productListTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCellHeight, kTableLength)] autorelease];
        self.productListTableView.showsVerticalScrollIndicator = YES;
        self.productListTableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        self.productListTableView.showsHorizontalScrollIndicator = NO;
        self.productListTableView.transform = CGAffineTransformMakeRotation(-M_PI*0.5);
        [self.productListTableView setFrame:CGRectMake(kRowHorizontalPadding * 0.5, kRowVerticalPadding * 0.5, kTableLength - kRowHorizontalPadding, kCellHeight)];
        
        self.productListTableView.rowHeight = kCellWidth;
        self.productListTableView.backgroundColor = kHorizontalTableBackgroundColor;
        
        self.productListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //self.productListTableView.separatorColor = [UIColor clearColor];
        
        self.productListTableView.dataSource = self;
        self.productListTableView.delegate = self;
        [self addSubview:self.productListTableView];
        
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductCell";
    
    __block ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[ProductCell alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellHeight)] autorelease];
    }
    
    __block Product *currentProduct = [self.products objectAtIndex:indexPath.row];
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{        
        UIImage *image = nil;
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentProduct.imgLink]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.thumbNail setImage:image]; 
        });
    }); 
    
    cell.titleLabel.text = currentProduct.name;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LJHWAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // Navigation logic may go here. Create and push another view controller.
    
    ProductDetailViewController *detailViewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:[NSBundle mainBundle]];
    detailViewController.product = [self.products objectAtIndex:indexPath.row];
    detailViewController.flag = 0;
    [appDelegate.navController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
}

@end
