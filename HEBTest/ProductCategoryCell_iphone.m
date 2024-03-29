//
//  ProductCategoryCell_iphone.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import "ProductCategoryCell_iphone.h"
#import "ControlVariables.h"
#import "ProductCell.h"
#import "ProductNameLabel.h"
#import "ProductDetailViewController.h"
#import "LJHWAppDelegate.h"
#import "Product.h"
#import "UIImageView+AFNetworking.h"
#import "ItemDetailViewController.h"
#import "UITableViewCell+FlatUI.h"

#import "UIFont+FlatUI.h"
#import "UIColor+FlatUI.h"

@implementation ProductCategoryCell_iphone

-(id)initWithFrame:(CGRect)frame
{
    if ((self=[super initWithFrame:frame]))
    {
        self.productListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCellHeight, kTableLength)];
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
        self.productListTableView.separatorColor = [UIColor cloudsColor];
        
        //Set the background color
        self.productListTableView.backgroundColor = [UIColor cloudsColor];
        self.productListTableView.backgroundView = nil;
        
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
        cell = [[ProductCell alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellHeight)];
    }
    
    Product *currentProduct = (self.products)[indexPath.row];
    
    [cell.thumbNail setImageWithURL:[NSURL URLWithString:currentProduct.imgLink] placeholderImage:nil];
    [cell setNeedsLayout];
    cell.titleLabel.text = currentProduct.name;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    id appDelegate = [[UIApplication sharedApplication] delegate];
    
    ProductDetailViewController *detailViewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:[NSBundle mainBundle]];
    detailViewController.product = (self.products)[indexPath.row];
    detailViewController.flag = 0;
    
    UITabBarController *tabBarController = ((LJHWAppDelegate*)appDelegate).tabBarController;
    UINavigationController *navController = (UINavigationController *)[tabBarController.viewControllers objectAtIndex:0];
    [navController pushViewController:detailViewController animated:YES];
    
}

@end
