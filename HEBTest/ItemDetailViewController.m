/*
     File: RecipeDetailViewController.m 
 Abstract: Table view controller to manage an editable table view that displays information about a product.
 The table view uses different cell types for different row types.
  
  Version: 1.4 
  
 Copyright (C) 2012 LJ Apps . All Rights Reserved. 
  
 */

#import "ItemDetailViewController.h"

#import "Product.h"
//#import "Ingredient.h"

//#import "InstructionsViewController.h"
//#import "TypeSelectionViewController.h"
#import "ProductPhotoViewController.h"
//#import "IngredientDetailViewController.h"
//#import "SSTheme.h"
//#import "ItemTypeSelectionViewController.h"
@interface ItemDetailViewController (PrivateMethods)
- (void)updatePhotoButton;
@end




@implementation ItemDetailViewController

@synthesize product;
//@synthesize ingredients;

@synthesize tableHeaderView;
@synthesize photoButton;
@synthesize nameTextField, overviewTextField, prepTimeTextField;


#define TYPE_SECTION 0
#define INGREDIENTS_SECTION 1
#define INSTRUCTIONS_SECTION 2


#pragma mark -
#pragma mark View controller

- (void)viewDidLoad {
    
//    [SSThemeManager customizeTableView:self.tableView];
    
    // Create and set the table header view.
    if (tableHeaderView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"DetailHeaderView" owner:self options:nil];
        self.tableView.tableHeaderView = tableHeaderView;
        self.tableView.allowsSelectionDuringEditing = YES;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
	
//    [photoButton setImage:product.thumbnailImage forState:UIControlStateNormal];
	self.navigationItem.title = product.name;
    nameTextField.text = product.name;    
    overviewTextField.text = product.category;
    prepTimeTextField.text = product.price;
	[self updatePhotoButton];

	/*
	 Create a mutable array that contains the product's ingredients ordered by displayOrder.
	 The table view uses this array to display the ingredients.
	 Core Data relationships are represented by sets, so have no inherent order. Order is "imposed" using the displayOrder attribute, but it would be inefficient to create and sort a new array each time the ingredients section had to be laid out or updated.
	 */
//	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
//	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
//	
//	NSMutableArray *sortedIngredients = [[NSMutableArray alloc] initWithArray:[product.ingredients allObjects]];
//	[sortedIngredients sortUsingDescriptors:sortDescriptors];
//	self.ingredients = sortedIngredients;

	
	// Update product type and ingredients on return.
    [self.tableView reloadData]; 
}


- (void)viewDidUnload {
    self.tableHeaderView = nil;
	self.photoButton = nil;
	self.nameTextField = nil;
	self.overviewTextField = nil;
	self.prepTimeTextField = nil;
	[super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
	[self updatePhotoButton];
	nameTextField.enabled = editing;
	overviewTextField.enabled = editing;
	prepTimeTextField.enabled = editing;
	[self.navigationItem setHidesBackButton:editing animated:YES];
	

	[self.tableView beginUpdates];
	
//    NSUInteger ingredientsCount = [product.ingredients count];
//    
//    NSArray *ingredientsInsertIndexPath = @[[NSIndexPath indexPathForRow:ingredientsCount inSection:INGREDIENTS_SECTION]];
//    
//    if (editing) {
//        [self.tableView insertRowsAtIndexPaths:ingredientsInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
//		overviewTextField.placeholder = @"Overview";
//	} else {
//        [self.tableView deleteRowsAtIndexPaths:ingredientsInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
//		overviewTextField.placeholder = @"";
//    }
    
    [self.tableView endUpdates];
	
	/*
	 If editing is finished, save the managed object context.
	 */
//	if (!editing) {
//		NSManagedObjectContext *context = product.managedObjectContext;
//		NSError *error = nil;
//		if (![context save:&error]) {
//			/*
//			 Replace this implementation with code to handle the error appropriately.
//			 
//			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//			 */
//			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//			abort();
//		}
//	}
}


//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//	
//	if (textField == nameTextField) {
//		product.name = nameTextField.text;
//		self.navigationItem.title = product.name;
//	}
//	else if (textField == overviewTextField) {
//		product.category = overviewTextField.text;
//	}
//	else if (textField == prepTimeTextField) {
//		product.price = prepTimeTextField.text;
//	}
//	return YES;
//}
//
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//	[textField resignFirstResponder];
//	return YES;
//}


#pragma mark -
#pragma mark UITableView Delegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    // Return a title or nil as appropriate for the section.
    switch (section) {
        case TYPE_SECTION:
            title = @"Category";
            break;
        case INGREDIENTS_SECTION:
            title = @"Ingredients";
            break;
        default:
            break;
    }
    return title;;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    /*
     The number of rows depends on the section.
     In the case of ingredients, if editing, add a row in editing mode to present an "Add Ingredient" cell.
	 */
    switch (section) {
        case TYPE_SECTION:
        case INSTRUCTIONS_SECTION:
            rows = 1;
            break;
        case INGREDIENTS_SECTION:
//            rows = [product.ingredients count];
//            if (self.editing) {
//                rows++;
//            }
            break;
		default:
            break;
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
     // For the Ingredients section, if necessary create a new cell and configure it with an additional label for the amount.  Give the cell a different identifier from that used for cells in other sections so that it can be dequeued separately.
//    if (indexPath.section == INGREDIENTS_SECTION) {
//		NSUInteger ingredientCount = [product.ingredients count];
        NSInteger row = indexPath.row;
		
//        if (indexPath.row < ingredientCount) {
//            // If the row is within the range of the number of ingredients for the current product, then configure the cell to show the ingredient name and amount.
//			static NSString *IngredientsCellIdentifier = @"IngredientsCell";
//			
//			cell = [tableView dequeueReusableCellWithIdentifier:IngredientsCellIdentifier];
//			
//			if (cell == nil) {
//				 // Create a cell to display an ingredient.
//				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IngredientsCellIdentifier];
//				cell.accessoryType = UITableViewCellAccessoryNone;
//			}
			
//            Ingredient *ingredient = ingredients[row];
//            cell.textLabel.text = ingredient.name;
//			cell.detailTextLabel.text = ingredient.amount;
//        } else {
//            // If the row is outside the range, it's the row that was added to allow insertion (see tableView:numberOfRowsInSection:) so give it an appropriate label.
//			static NSString *AddIngredientCellIdentifier = @"AddIngredientCell";
//			
//			cell = [tableView dequeueReusableCellWithIdentifier:AddIngredientCellIdentifier];
//			if (cell == nil) {
//				 // Create a cell to display "Add Ingredient".
//				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddIngredientCellIdentifier];
//				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//			}
//            cell.textLabel.text = @"Add Ingredient";
//        }
//    } else {
//         // If necessary create a new cell and configure it appropriately for the section.  Give the cell a different identifier from that used for cells in the Ingredients section so that it can be dequeued separately.
//        static NSString *MyIdentifier = @"GenericCell";
//        
//        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//        
//        NSString *text = nil;
//        
//        switch (indexPath.section) {
//            case TYPE_SECTION: // type -- should be selectable -> checkbox
//                text = [product.type valueForKey:@"name"];
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                break;
//            case INSTRUCTIONS_SECTION: // instructions
//                text = @"Instructions";
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                cell.editingAccessoryType = UITableViewCellAccessoryNone;
//                break;
//            default:
//                break;
//        }
//        
//        cell.textLabel.text = text;
//    }
    return cell;
}





#pragma mark -
#pragma mark Photo

- (IBAction)photoTapped {
    // If in editing state, then display an image picker; if not, create and push a photo view controller.
		
    ProductPhotoViewController *productPhotoViewController = [[ProductPhotoViewController alloc] init];
    productPhotoViewController.hidesBottomBarWhenPushed = YES;
    productPhotoViewController.product = product;
    [self.navigationController pushViewController:productPhotoViewController animated:YES];
	
}



@end
