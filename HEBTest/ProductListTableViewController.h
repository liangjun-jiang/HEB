 /*
     File: RecipeListTableViewController.h
 Abstract: Table view controller to manage an editable table view that displays a list of recipes.
 Recipes are displayed in a custom table view cell.
 
  Version: 1.4
 
  
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import <CoreData/CoreData.h>

@class Product;
@class ProductTableViewCell;

@interface ProductListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    @private
        NSFetchedResultsController *fetchedResultsController;
        NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)showProduct:(Product *)recipe animated:(BOOL)animated;
- (void)configureCell:(ProductTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
