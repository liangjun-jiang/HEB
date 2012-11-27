//
//  ProductDetailViewController.h
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Product;
@interface ProductDetailViewController : UIViewController{
}


@property (strong, nonatomic) Product *product;

@property (strong, nonatomic) IBOutlet UILabel *expirationLabel;

@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *addIntoListButton;
@property (nonatomic,assign) NSUInteger flag;


-(IBAction)addIntoList;

@end

