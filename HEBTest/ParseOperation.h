//
//  ParseOperation.h
//  HEBTest
//
//  Created by Liangjun Jiang on 1/18/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
extern NSString *kAddNotif;
extern NSString *kResultsKey;
extern NSString *kErrorNotif;
extern NSString *kMsgErrorKey;
*/
@class Product;


@interface ParseOperation : NSOperation {
    NSData *resultData;
    
    @private
    Product *currentProduct;
    NSDateFormatter *dateFormater;
    NSDateFormatter *dateFormatter;
    BOOL accumulatingParsedCharacterData;
    BOOL didAbortParsing;
    NSUInteger parsedCounter;
    
}

@property (copy, readonly) NSData *resultData;

-(id)initWithData:(NSData *)paraseData;

@end
