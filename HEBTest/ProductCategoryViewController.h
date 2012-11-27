//
//  ProductCategoryViewController.h
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCategoryViewController : UITableViewController
{
    @private
    NSMutableArray *_allEntries;
    NSOperationQueue *_queue;
    NSArray *_feeds;
    
}

@property(strong,nonatomic) NSString *storeId;
@property (strong) NSOperationQueue *queue;
@property (strong) NSMutableArray *allEntries;
@property (strong) NSArray *feeds;

@property (strong,nonatomic) NSMutableDictionary *categories;
@property (strong, nonatomic) NSMutableArray *reusableCells;

@property (strong, nonatomic)NSMutableArray *productList;


@end
