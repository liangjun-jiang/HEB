/*
 Disclaimer: IMPORTANT:  This About Objects software is supplied to you by
 About Objects, Inc. ("AOI") in consideration of your agreement to the 
 following terms, and your use, installation, modification or redistribution
 of this AOI software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this AOI software.
 
 Copyright (C) About Objects, Inc. 2009. All rights reserved.
 */
#import <Foundation/Foundation.h>

@interface UIImage (Resizing)

+ (UIImage *)imageOfSize:(CGSize)size fromImage:(UIImage *)image;

- (UIImage *)imageScaledToSize:(CGSize)size;

@end
