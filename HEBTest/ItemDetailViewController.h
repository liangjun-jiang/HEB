/*
     File: RecipeDetailViewController.h
 Abstract: Table view controller to manage an editable table view that displays information about a recipe.
 The table view uses different cell types for different row types.
 
  Version: 1.4
 
 
 Copyright (C) 2012 LJ Apps . All Rights Reserved.
 
 */

@class Product;

@interface ItemDetailViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate> {
    @private
        Product *product;
    
        UIView *tableHeaderView;    
        UIButton *photoButton;
        UITextField *nameTextField;
        UITextField *overviewTextField;
        UITextField *prepTimeTextField;
}
            
@property (nonatomic, strong) Product *product;

@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic, strong) IBOutlet UIButton *photoButton;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UITextField *overviewTextField;
@property (nonatomic, strong) IBOutlet UITextField *prepTimeTextField;

- (IBAction)photoTapped;

@end
