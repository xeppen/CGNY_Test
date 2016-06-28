//
//  CGNYImageData.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import "CGNYImageData.h"

@implementation CGNYImageData

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
    }
    return self;
}

- (void)setDictionary:(NSDictionary *)dictionary
{
    self.imgUrl = dictionary[@"media"][@"m"] ?  : @"";
    self.title = dictionary[@"title"] ? : @"";
}

@end
