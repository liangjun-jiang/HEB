/*
     File: RecipeTableViewCell.m 
 Abstract: A table view cell that displays information about a Recipe.  It uses individual subviews of its content view to show the name, picture, description, and preparation time for each recipe.  If the table view switches to editing mode, the cell reformats itself to move the preparation time off-screen, and resizes the name and description fields accordingly.
  
  Version: 1.4 
  
 Copyright (C) 2010 Apple Inc. All Rights Reserved. 
  
 */

#import "ProductTableViewCell.h"

#pragma mark -
#pragma mark SubviewFrames category

@interface ProductTableViewCell (SubviewFrames)
- (CGRect)_imageViewFrame;
- (CGRect)_nameLabelFrame;
- (CGRect)_descriptionLabelFrame;
- (CGRect)_prepTimeLabelFrame;
@end


#pragma mark -
#pragma mark RecipeTableViewCell implementation

@implementation ProductTableViewCell

@synthesize product, imageView, nameLabel, priceLabel, eDateLabel;


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];

        priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [priceLabel setFont:[UIFont systemFontOfSize:12.0]];
        [priceLabel setTextColor:[UIColor darkGrayColor]];
        [priceLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:priceLabel];

        eDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        eDateLabel.textAlignment = UITextAlignmentRight;
        [eDateLabel setFont:[UIFont systemFontOfSize:12.0]];
        [eDateLabel setTextColor:[UIColor blackColor]];
        [eDateLabel setHighlightedTextColor:[UIColor whiteColor]];
		eDateLabel.minimumFontSize = 7.0;
		eDateLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [self.contentView addSubview:eDateLabel];

        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:nameLabel];
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
	
    [imageView setFrame:[self _imageViewFrame]];
    [nameLabel setFrame:[self _nameLabelFrame]];
    [priceLabel setFrame:[self _descriptionLabelFrame]];
    [eDateLabel setFrame:[self _prepTimeLabelFrame]];
    if (self.editing) {
        eDateLabel.alpha = 0.0;
    } else {
        eDateLabel.alpha = 1.0;
    }
}


#define IMAGE_SIZE          42.0
#define EDITING_INSET       10.0
#define TEXT_LEFT_MARGIN    8.0
#define TEXT_RIGHT_MARGIN   5.0
#define PREP_TIME_WIDTH     80.0

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */
- (CGRect)_imageViewFrame {
    if (self.editing) {
        return CGRectMake(EDITING_INSET, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
	else {
        return CGRectMake(0.0, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
}

- (CGRect)_nameLabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - PREP_TIME_WIDTH, 16.0);
    }
}

- (CGRect)_descriptionLabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_LEFT_MARGIN, 16.0);
    }
}

- (CGRect)_prepTimeLabelFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - PREP_TIME_WIDTH - TEXT_RIGHT_MARGIN, 4.0, PREP_TIME_WIDTH, 16.0);
}


#pragma mark -
#pragma mark Recipe set accessor

- (void)setProduct:(Product *)newProduct {
    if (newProduct != product) {
        product = newProduct;
	}
//	imageView.image = product.imgLink;
	nameLabel.text = product.name;
	priceLabel.text = product.price;
	eDateLabel.text = product.eDate;
}

@end
