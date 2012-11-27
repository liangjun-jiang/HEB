/*
     File: RecipePhotoViewController.h
 Abstract: View controller to manage a view to display a recipe's photo.
 The image view is created programmatically.
 
  Version: 1.4
 
 
 
 Copyright (C) 2012 LJ Apps . All Rights Reserved.
 
 */

@class Product;

@interface ProductPhotoViewController : UIViewController {
    @private
        Product *product;
        UIImageView *imageView;
}

@property(nonatomic, strong) Product *product;
@property(nonatomic, strong) UIImageView *imageView;

@end
