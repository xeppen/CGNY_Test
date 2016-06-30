//
//  NSJSONSerialization+Additions.m
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//
//  Helper method to remove keys with null value.
//

#import "NSJSONSerialization+Additions.h"

@implementation NSJSONSerialization (Additions)

+ (id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError *__autoreleasing *)error removeKeysWithNullValue:(BOOL)removeKeysWithNullValue
{
    id result = nil;
    @try {
        result = [self JSONObjectWithData:data options:opt error:error];
    }
    @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"CGNYDomain" code:-1 userInfo:@{
                                                                                 NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Exception: %@  while parsing JSON, check \"exception\" key!", exception.name],
                                                                                 @"exception" : exception
                                                                                 }];
        return nil;
    }
    @finally {
        
    }
    
    if (!removeKeysWithNullValue)
    {
        return result;
    }
    if ([result isKindOfClass:[NSArray class]])
    {
        return [self arrayWithoutNullKeysFromArray:(NSArray *)result];
    }
    else if ([result isKindOfClass:[NSDictionary class]])
    {
        return [self dictionaryWithoutNullKeysFromDictionary:(NSDictionary *)result];
    }
    return result;
}

+ (NSDictionary *)dictionaryWithoutNullKeysFromDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    for (id key in [dictionary allKeys])
    {
        id object = dictionary[key];
        if (![object isKindOfClass:[NSNull class]])
        {
            if ([object isKindOfClass:[NSArray class]])
            {
                //Loop through array
                mutableDictionary[key] = [self arrayWithoutNullKeysFromArray:(NSArray *)object];
            }
            else if ([object isKindOfClass:[NSDictionary class]])
            {
                //Filter the dictionary
                mutableDictionary[key] = [self dictionaryWithoutNullKeysFromDictionary:(NSDictionary *)object];
            }
            else
            {
                //Just add the object
                mutableDictionary[key] = object;
            }
        }
    }
    
    return [dictionary isKindOfClass:[NSMutableDictionary class]] ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

+ (NSArray *)arrayWithoutNullKeysFromArray:(NSArray *)array
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (id object in array)
    {
        if (![object isKindOfClass:[NSNull class]])
        {
            if ([object isKindOfClass:[NSArray class]])
            {
                //Loop through array
                [mutableArray addObject:[self arrayWithoutNullKeysFromArray:(NSArray *)object]];
            }
            else if ([object isKindOfClass:[NSDictionary class]])
            {
                //Filter the dictionary
                [mutableArray addObject:[self dictionaryWithoutNullKeysFromDictionary:(NSDictionary *)object]];
            }
            else
            {
                //Just add the object
                [mutableArray addObject:object];
            }
        }
    }
    
    return [array isKindOfClass:[NSMutableArray class]] ? mutableArray : [NSArray arrayWithArray:mutableArray];
}


@end
