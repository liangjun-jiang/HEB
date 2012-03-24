//
//  ProductCell.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import "ProductCell.h"
#import "ProductNameLabel.h"
#import "ControlVariables.h"
@implementation ProductCell
@synthesize thumbNail=_thumbNail, titleLabel=_titleLabel;

-(NSString *)reuseIdentifier
{
    return @"ProductCell";
}

-(void)dealloc
{
    self.thumbNail = nil;
    self.titleLabel = nil;
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        //[super initWithFrame:frame];
        self.thumbNail = [[[UIImageView alloc] initWithFrame:CGRectMake(kProductCellHorizontalInnerpadding, kProductCellVerticalInnerPadding, kCellWidth-kProductCellHorizontalInnerpadding*2, kCellHeight-kProductCellVerticalInnerPadding*2)] autorelease];
        self.thumbNail.opaque = YES;
        [self.thumbNail setContentMode:UIViewContentModeScaleAspectFit];
        
        [self.contentView addSubview:self.thumbNail];
        
        self.titleLabel = [[[ProductNameLabel alloc] initWithFrame:CGRectMake(0, self.thumbNail.frame.size.height*0.632, self.thumbNail.frame.size.width, self.thumbNail.frame.size.height*0.37)] autorelease];
        self.titleLabel.opaque = YES;
        [self.titleLabel setPersistentBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        self.titleLabel.numberOfLines = 2;
        [self.thumbNail addSubview:self.titleLabel];
        
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:self.thumbNail.frame] autorelease];
        self.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
        self.transform = CGAffineTransformMakeRotation(M_PI*0.5);
   }
    return self;
}

@end
