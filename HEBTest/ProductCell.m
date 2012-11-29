//
//  ProductCell.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/15/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
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


-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        //[super initWithFrame:frame];
        self.thumbNail = [[UIImageView alloc] initWithFrame:CGRectMake(kProductCellHorizontalInnerpadding, kProductCellVerticalInnerPadding, kCellWidth-kProductCellHorizontalInnerpadding*2, kCellHeight-kProductCellVerticalInnerPadding*2)];
        self.thumbNail.opaque = YES;
        [self.thumbNail setContentMode:UIViewContentModeScaleAspectFit];
        
        [self.contentView addSubview:self.thumbNail];
        
        self.titleLabel = [[ProductNameLabel alloc] initWithFrame:CGRectMake(0, self.thumbNail.frame.size.height*0.632, self.thumbNail.frame.size.width, self.thumbNail.frame.size.height*0.37)];
        self.titleLabel.opaque = YES;
        [self.titleLabel setPersistentBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        self.titleLabel.numberOfLines = 2;
        [self.thumbNail addSubview:self.titleLabel];
        
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.thumbNail.frame];
        self.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
        self.transform = CGAffineTransformMakeRotation(M_PI*0.5);
        
        //http://blog.slaunchaman.com/2011/08/14/cocoa-touch-circumventing-uitableviewcell-redraw-issues-with-multithreading/
        if (self) {
            [self.thumbNail addObserver:self
                               forKeyPath:@"image"
                                  options:NSKeyValueObservingOptionOld
                                  context:NULL];
        }
   }
    return self;
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
    if (object == self.thumbNail &&
        [keyPath isEqualToString:@"image"] &&
        ([change objectForKey:NSKeyValueChangeOldKey] == nil ||
         [change objectForKey:NSKeyValueChangeOldKey] == [NSNull null])) {
            [self setNeedsLayout];
        }
}


- (void)dealloc
{
    [self.thumbNail removeObserver:self forKeyPath:@"image"];
}

@end
