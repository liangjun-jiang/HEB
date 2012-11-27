//
//  ProductCell.h
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductNameLabel;

@interface ProductCell : UITableViewCell

@property (strong, nonatomic) UIImageView *thumbNail;
@property (strong, nonatomic) ProductNameLabel *titleLabel;

@end
