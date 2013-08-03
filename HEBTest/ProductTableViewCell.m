/*
     File: RecipeTableViewCell.m 
 Abstract: A table view cell that displays information about a Recipe.  It uses individual subviews of its content view to show the name, picture, description, and preparation time for each recipe.  If the table view switches to editing mode, the cell reformats itself to move the preparation time off-screen, and resizes the name and description fields accordingly.
  
  Version: 1.4 
  
 Copyright (C) 2013 LJApps. All Rights Reserved. 
  
 */

#import "ProductTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDateFormatter+ThreadSafe.h"

#import "UIColor+FlatUI.h"
#pragma mark -
#pragma mark SubviewFrames category


@implementation ProductTableViewCell

@synthesize product;


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

	if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {

        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        UIColor *color= [UIColor greenSeaColor];
        UIColor *selectedColor = [UIColor cloudsColor];
        
        FUICellBackgroundView* backgroundView = [FUICellBackgroundView new];
        backgroundView.backgroundColor = color;
        self.backgroundView = backgroundView;
        
        FUICellBackgroundView* selectedBackgroundView = [FUICellBackgroundView new];
        selectedBackgroundView.backgroundColor = selectedColor;
        self.selectedBackgroundView = selectedBackgroundView;
        
        //The labels need a clear background color or they will look very funky
        self.textLabel.backgroundColor = [UIColor clearColor];
        if ([self respondsToSelector:@selector(detailTextLabel)])
            self.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        //Guess some good text colors
        self.textLabel.textColor = selectedColor;
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        self.textLabel.highlightedTextColor = color;
        if ([self respondsToSelector:@selector(detailTextLabel)]) {
            self.detailTextLabel.textColor = selectedColor;
            self.detailTextLabel.highlightedTextColor = color;
            self.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
        }

        
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
    
    NSRange range = [product.eDate rangeOfString:@"23:59"];
    NSString *trimmed;
    if (range.length >0) {
        trimmed = [product.eDate substringWithRange:NSMakeRange(0, range.location)];
        self.detailTextLabel.text =  [NSString stringWithFormat:@"%@, before:%@", product.price,trimmed];
    }
     
    
    
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


- (void)setCornerRadius:(CGFloat)cornerRadius {
    [(FUICellBackgroundView*)self.backgroundView setCornerRadius:cornerRadius];
    [(FUICellBackgroundView*)self.selectedBackgroundView setCornerRadius:cornerRadius];
}

- (void)setSeparatorHeight:(CGFloat)separatorHeight {
    [(FUICellBackgroundView*)self.backgroundView setSeparatorHeight:separatorHeight];
    [(FUICellBackgroundView*)self.selectedBackgroundView setSeparatorHeight:separatorHeight];
}


@end
