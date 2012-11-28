//
//  SavedProduct.h
//  HEBTest
//
//  Created by LIANGJUN JIANG on 11/28/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SavedProduct : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * imgLink;
@property (nonatomic, retain) NSString * eDate;
@property (nonatomic, retain) NSString * psDate;
@property (nonatomic, retain) NSString * desc;

@end
