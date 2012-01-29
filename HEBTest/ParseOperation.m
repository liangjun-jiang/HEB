//
//  ParseOperation.m
//  HEBTest
//
//  Created by Liangjun Jiang on 1/18/12.
//  Copyright (c) 2012 Harvard University Extension School. All rights reserved.
//

#import "ParseOperation.h"
#import "Product.h"



//NSNotification name of ..
NSString *kAddNotif = @"AddNotif";
NSString *kResultsKey = @"ResultsKey";
NSString *kErrorNotif = @"ErrorNotif";
NSString *kMsgErrorKey = @"MsgErrorKey";

@interface ParseOperation() <NSXMLParserDelegate>
    @property(nonatomic, retain) Product *currentProduct;
    @property(nonatomic, retain) NSMutableArray *currentParseBatch;
    @property(nonatomic, retain) NSMutableString *currentParsedCharacterData;
    @property (nonatomic, assign) NSUInteger parsedCount;
@end

@implementation ParseOperation
@synthesize currentProduct, currentParseBatch, currentParsedCharacterData, parsedCount;
@synthesize resultData;

-(id)initWithData:(NSData *)parseData
{
    if ((self = [super init])) {
        resultData = [parseData copy]; // I need to understand this !!!
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'"];
    }
   
    return self;
}

-(void)addProductsToList:(NSArray *)products
{
    assert([NSThread isMainThread]);
    for (Product *product in products) {
        NSLog(@"name: %@", product.price);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddNotif object:self userInfo:[NSDictionary dictionaryWithObject:products forKey:kResultsKey]];
}

// the main function for this NSOperation, to start the parsing
-(void)main
{
    currentParseBatch = [NSMutableArray array];
    currentParsedCharacterData = [NSMutableString string];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:resultData];
    [parser setDelegate:self];
    [parser parse];
    
    if ([self.currentParseBatch count] > 0) {
        [self performSelectorOnMainThread:@selector(addProductsToList:) withObject:currentParseBatch waitUntilDone:NO];
    }
    
    currentParseBatch = nil;
    currentProduct = nil;
    currentParsedCharacterData = nil;
    
    [parser release];
}

-(void)dealloc
{
    [currentProduct release];
    [currentParsedCharacterData release];
    [resultData release];
    [currentParseBatch release];
    [dateFormatter release];
    [super dealloc];
}

//
static const const NSUInteger kMaximumNumberOfProductsToParse = 50;

static NSUInteger const kSizeOfProductBatch = 10;

static NSString *const kItemElementName = @"item";
static NSString *const kTitleElementName = @"title";
static NSString *const kpsDateElementName = @"vertis:psDate";
static NSString *const kItemImageElementName = @"vertis:itemimage";
static NSString *const kPriceElementName = @"vertis:price";
static NSString *const kMoreElementName = @"vertis:morePrice";
static NSString *const kDescElementName = @"description";
static NSString *const kMoreCateogry1ElementName = @"category";
static NSString *const kMoreCateogry2ElementName = @"vertics:category2";

#pragma mark NSXMLParser delegate method
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kItemElementName]) {
        Product *product = [[Product alloc] init];
        self.currentProduct = product;
        //NSLog(@"product current: %@",self.currentProduct);
       [product release];
    } else if ([elementName isEqualToString:kTitleElementName] ||
               [elementName isEqualToString:kpsDateElementName] ||
               [elementName isEqualToString:kItemImageElementName] ||
               [elementName isEqualToString:kMoreCateogry1ElementName] ||
               [elementName isEqualToString:kPriceElementName] ||
               [elementName isEqualToString:kMoreElementName]
               )
    {
        accumulatingParsedCharacterData = YES;
        [currentParsedCharacterData setString:@""];
    }
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:kItemElementName]) {
        
        [self.currentParseBatch addObject:self.currentProduct];
        parsedCount ++;
        if ([self.currentParseBatch count] >=kMaximumNumberOfProductsToParse) {
            [self performSelectorOnMainThread:@selector(addProductsToList:) withObject:self.currentParseBatch waitUntilDone:NO];
            self.currentParseBatch = [NSMutableArray array];
         
        }
    } else if ([elementName isEqualToString:kTitleElementName])
    {
        if (self.currentProduct != nil) {
            self.currentProduct.name = self.currentParsedCharacterData;
            //NSLog(@"name: %@", self.currentProduct.name);
        }
        
    }else if ([elementName isEqualToString:kpsDateElementName])
    {
        if (self.currentProduct != nil) {
            currentProduct.psDate = [dateFormater dateFromString:currentParsedCharacterData];
            //NSLog(@"date: %@", self.currentProduct.psDate);
        }
    }  
    else if ([elementName isEqualToString:kItemImageElementName])
    {
        if (self.currentProduct != nil) {
            self.currentProduct.imgLink = self.currentParsedCharacterData;
            //NSLog(@"imgLink: %@",self.currentProduct.imgLink);
        }
        
    } else if ([elementName isEqualToString:kMoreCateogry1ElementName])
    {
        if (self.currentProduct != nil) {
            self.currentProduct.category = self.currentParsedCharacterData;
            //NSLog(@"category: %@", self.currentProduct.category);
        }
        
    } else if ([elementName isEqualToString:kPriceElementName])
    {
        if (self.currentProduct != nil) {
            self.currentProduct.price = self.currentParsedCharacterData;
            //NSLog(@"price: %@", self.currentProduct.price);
        }
        
    }  else if ([elementName isEqualToString:kMoreElementName])
    {
        if (self.currentProduct != nil) {
            self.currentProduct.more = self.currentParsedCharacterData;
            //NSLog(@"more: %@", self.currentProduct.more);
        }
    } else if ([elementName isEqualToString:kDescElementName])
    {
        if (self.currentProduct != nil) {
            self.currentProduct.desc = self.currentParsedCharacterData;
            //NSLog(@"desc: %@", self.currentProduct.desc);
        }
    }   
    
    accumulatingParsedCharacterData = NO;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (accumulatingParsedCharacterData) {
        [currentParsedCharacterData appendString:string];
    }
}


-(void)handleParseError:(NSError *)parseError
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kErrorNotif object:self userInfo:[NSDictionary dictionaryWithObject:parseError forKey:kMsgErrorKey]];
}


-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if ([parseError code] != NSXMLParserDelegateAbortedParseError && !didAbortParsing) {
        [self performSelectorOnMainThread:@selector(handleParseError:) withObject:parseError waitUntilDone:NO];
    }
}

@end
