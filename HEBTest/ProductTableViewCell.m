/*
     File: RecipeTableViewCell.m 
 Abstract: A table view cell that displays information about a Recipe.  It uses individual subviews of its content view to show the name, picture, description, and preparation time for each recipe.  If the table view switches to editing mode, the cell reformats itself to move the preparation time off-screen, and resizes the name and description fields accordingly.
  
  Version: 1.4 
  
 Copyright (C) 2013 LJApps. All Rights Reserved. 
  
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
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        //http://blog.slaunchaman.com/2011/08/14/cocoa-touch-circumventing-uitableviewcell-redraw-issues-with-multithreading/
        if (self) {
            [[self imageView] addObserver:self
                               forKeyPath:@"image"
                                  options:NSKeyValueObservingOptionOld
                                  context:NULL];
        }
        
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
    self.detailTextLabel.text =  [NSString stringWithFormat:@"%@, expired on:%@", product.price, product.eDate];
    
    
}


// The reason we’re observing changes is that if you create a table view cell, return it to the
// table view, and then later add an image (perhaps after doing some background processing), you
// need to call -setNeedsLayout on the cell for it to add the image view to its view hierarchy. We
// asked the change dictionary to contain the old value because this only needs to happen if the
// image was previously nil.
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == [self imageView] &&
        [keyPath isEqualToString:@"image"] &&
        ([change objectForKey:NSKeyValueChangeOldKey] == nil ||
         [change objectForKey:NSKeyValueChangeOldKey] == [NSNull null])) {
            [self setNeedsLayout];
        }
}


@end
