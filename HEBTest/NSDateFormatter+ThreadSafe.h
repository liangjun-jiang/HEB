//
//  NSDateFormatter+ThreadSafe.h
//  TGSWA
//
//  Created by LIANGJUN JIANG on 3/12/13.
//  Copyright (c) 2013 Harvard University Extension School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (ThreadSafe)

+ (NSDateFormatter *)dateReader;
+ (NSDateFormatter *)dateWriter;

@end
