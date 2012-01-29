//
//  ProductNameLabel.m
//  HorizontalTables
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 Felipe Laso. All rights reserved.
//

#import "ProductNameLabel.h"
#import "ControlVariables.h"

@implementation ProductNameLabel

-(void)setPersistentBackgroundColor:(UIColor *)color
{
    super.backgroundColor = color;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    
}

-(void)drawTextInRect:(CGRect)rect{
    CGFloat newWidth = rect.size.width - kProductTitleLabelPadding;
    CGFloat newHeight = rect.size.height;
    
    CGRect newRect = CGRectMake(kProductTitleLabelPadding*0.5, 0, newWidth, newHeight);
    
    [super drawTextInRect:newRect];
    
}

@end
