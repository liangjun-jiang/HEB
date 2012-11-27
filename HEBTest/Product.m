//
//  Product.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/18/12.
//  Copyright (c) 2012 LJ Apps. All rights reserved.
//

#import "Product.h"

@implementation Product 
@synthesize name, price, imgLink, category, desc;
@synthesize psDate, eDate;


+(NSArray *)keys
{
    return @[@"name", @"price", @"imgLink",@"desc", @"category", @"psDate", @"eDate"];
}

+(NSDateFormatter *)dateFormatter
{
    return nil;
}

-(id)init
{
    self = [super init];
    [self setName:@""];
    [self setPrice:@""];
    [self setImgLink:@""];
    [self setDesc:@""];
    [self setCategory:@""];
    [self setPsDate:@""];
    [self setEDate:@""];
    
    return self;
}

-(id)initWithInfo:(NSString*)iName price:(NSString*)iPrice image:(NSString *)iImage desc:(NSString*)iDesc category:(NSString *)iCategory psDate:(NSDate *)iDate endingDate:(NSString *)endDate
{
    if ((self = [super init]))
    {
        name = [iName copy];
        price = [iPrice copy];
        imgLink = [iImage copy];
        desc = [iDesc copy];
        category = [iCategory copy];
        psDate = [iDate copy];
        eDate = [endDate copy];
        
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    [self setValuesForKeysWithDictionary:dictionary];
    return self;
}

-(void)processImageDataWithBlock:(void (^)(NSData *imageData))processImage
{
    NSString *url = imgLink;
    NSString *new_url = [url stringByReplacingOccurrencesOfString:@"small" withString:@"large"];
    dispatch_queue_t callerQueue = dispatch_get_current_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("thumbnail download", NULL);
    dispatch_async(downloadQueue, ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:new_url]];
        if (imgData == nil) {
            imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        }
        dispatch_async(callerQueue, ^{
            processImage(imgData); 
        });
    });
    dispatch_release(downloadQueue);
}

@end
