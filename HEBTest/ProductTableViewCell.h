/*
     File: RecipeTableViewCell.h
 Abstract: A table view cell that displays information about a Recipe.  It uses individual subviews of its content view to show the name, picture, description, and preparation time for each recipe.  If the table view switches to editing mode, the cell reformats itself to move the preparation time off-screen, and resizes the name and description fields accordingly.
 
  Version: 1.4
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "SavedProduct.h"

@interface ProductTableViewCell : UITableViewCell {
    SavedProduct *product;
    
}

@property (nonatomic, retain) SavedProduct *product;


@end
