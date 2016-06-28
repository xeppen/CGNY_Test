//
//  CGNYImageData.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import "CGNYImageData.h"
#import "CGNYDataService.h"

@implementation CGNYImageData

#pragma mark - Initializers

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
    }
    return self;
}

#pragma mark - Setters

- (void)setDictionary:(NSDictionary *)dictionary
{
    self.imgUrl = dictionary[@"media"][@"m"] ?  : @"";
    self.title = dictionary[@"title"] ? : @"";
}

-(void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    [CGNYDataService fetchImageFromUrl:imgUrl withCompletion:^(UIImage *image, NSError *error) {
        if(error)
        {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        self.image = image;
    }];
}
@end
