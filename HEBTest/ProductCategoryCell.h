//
//  ProductCategoryCell.h
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCategoryCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) UITableView *productListTableView;
@property (strong, nonatomic) NSArray *products;
@end
