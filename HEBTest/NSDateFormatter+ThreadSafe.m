//
//  NSDateFormatter+ThreadSafe.m
//  TGSWA
//
//  Created by LIANGJUN JIANG on 3/12/13.
//  Copyright (c) 2013 Harvard University Extension School. All rights reserved.
//

#import "NSDateFormatter+ThreadSafe.h"

@implementation NSDateFormatter (ThreadSafe)

+ (NSDateFormatter *)dateReader
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateReader = [dictionary objectForKey:@"SCDateReader"];
    if (!dateReader)
    {
        dateReader = [[NSDateFormatter alloc] init];
        dateReader.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateReader.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        dateReader.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";
        [dictionary setObject:dateReader forKey:@"SCDateReader"];
    }
    return dateReader;
}

+ (NSDateFormatter *)dateWriter
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateWriter = [dictionary objectForKey:@"SCDateWriter"];
    if (!dateWriter)
    {
        dateWriter = [[NSDateFormatter alloc] init];
        dateWriter.locale = [NSLocale currentLocale];
        dateWriter.timeZone = [NSTimeZone defaultTimeZone];
        dateWriter.dateStyle = NSDateFormatterMediumStyle;
        [dictionary setObject:dateWriter forKey:@"SCDateWriter"];
    }
    return dateWriter;
}

@end
