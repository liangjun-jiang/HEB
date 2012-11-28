/*
     File: RecipeTableViewCell.m 
 Abstract: A table view cell that displays information about a Recipe.  It uses individual subviews of its content view to show the name, picture, description, and preparation time for each recipe.  If the table view switches to editing mode, the cell reformats itself to move the preparation time off-screen, and resizes the name and description fields accordingly.
  
  Version: 1.4 
  
 Copyright (C) 2010 Apple Inc. All Rights Reserved. 
  
 */

#import "ProductTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#pragma mark -
#pragma mark SubviewFrames category


@implementation ProductTableViewCell

@synthesize product;


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

	if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {

        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.textLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [self.textLabel setTextColor:[UIColor blackColor]];
        [self.textLabel setHighlightedTextColor:[UIColor whiteColor]];
        
        [self.detailTextLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.detailTextLabel setTextColor:[UIColor blackColor]];
        [self.detailTextLabel setHighlightedTextColor:[UIColor whiteColor]];
        
    }

    return self;
}


#pragma mark -
#pragma mark Laying out subviews

/*
 To save space, the prep time label disappears during editing.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
	
}


- (void)setProduct:(SavedProduct *)newProduct {
    if (newProduct != product) {
        product = newProduct;
	}
    [self.imageView setImageWithURL:[NSURL URLWithString:product.imgLink]];
	
    self.textLabel.text = product.name;
    self.detailTextLabel.text =  [NSString stringWithFormat:@"%@, ending:%@", product.price, product.eDate];

}

@end
