/*
     File: RecipePhotoViewController.m 
 Abstract: View controller to manage a view to display a recipe's photo.
 The image view is created programmatically.
  
  Version: 1.4 
  
  
 Copyright (C) 2012 LJ Apps . All Rights Reserved. 
  
 */

#import "ProductPhotoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Product.h"

@implementation ProductPhotoViewController

@synthesize product;
@synthesize imageView;

- (void)loadView {
	self.title = @"Photo";

    imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor blackColor];
    
    self.view = imageView;
}


- (void)viewWillAppear:(BOOL)animated {
    [imageView setImageWithURL:[NSURL URLWithString:product.imgLink] placeholderImage:nil];
//    imageView.image = [product.image valueForKey:@"image"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




@end
