//
//  Product.h
//  HEBTest
//
//  Created by Liangjun Jiang on 1/18/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@property(nonatomic,retain) NSString *category;
@property(nonatomic,retain) NSString *name;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *imgLink;
@property (nonatomic, retain) NSString *psDate;
@property (nonatomic, retain) NSString *eDate;

@property (nonatomic, retain) NSString *desc;

+(NSArray *)keys;
-(id)initWithDictionary:(NSDictionary *)dictionary;
-(void)processImageDataWithBlock:(void (^)(NSData *imageData))processImage;
-(id)initWithInfo:(NSString*)iName price:(NSString*)iPrice image:(NSString *)iImage desc:(NSString*)iDesc category:(NSString *)iCategory psDate:(NSString *)iDate endingDate:(NSString *)eDate;

@end
