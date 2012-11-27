//
//  ProductCategoryCell.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import "ProductCategoryCell.h"
#import "ProductCell.h"
#import "ControlVariables.h"

@implementation ProductCategoryCell
@synthesize productListTableView=_productListTableView, products=_products;



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.products count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ProductCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = @"The title of the cell in the table within the table :O";
    
    return cell;
}


-(NSString *)reuseIdentifier
{
    return @"ProductCategoryCell";
}

@end
