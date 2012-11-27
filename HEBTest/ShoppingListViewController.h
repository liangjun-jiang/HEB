//
//  ShoppingListViewController.h
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShoppingListViewController : UITableViewController
{
    NSMutableArray *_selectedProducts;
}

@property (nonatomic, strong) NSMutableArray *selectedProducts;

+(NSString *)pathForDocumentsWithName:(NSString *)documentName;

//-(void)add;
-(void)save;
-(void)addObject:(id)anObject;

@end
