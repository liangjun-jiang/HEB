//
//  Product.h
//  HEBTest
//
//  Created by Liangjun Jiang on 1/18/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Product : NSObject
{
    
    NSString *category;
    NSString *name;
    NSString *price;
    NSString *imgLink;
    NSString *psDate;
    NSString *eDate;
    NSString *desc;
}
@property(nonatomic,strong) NSString *category;
@property(nonatomic,strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *imgLink;
@property (nonatomic, strong) NSString *psDate;
@property (nonatomic, strong) NSString *eDate;

@property (nonatomic, strong) NSString *desc;

+(NSArray *)keys;
-(id)initWithDictionary:(NSDictionary *)dictionary;
-(id)initWithInfo:(NSString*)iName price:(NSString*)iPrice image:(NSString *)iImage desc:(NSString*)iDesc category:(NSString *)iCategory psDate:(NSString *)iDate endingDate:(NSString *)eDate;

@end
