//
//  CGNYImageData.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import "CGNYImageData.h"

@implementation CGNYImageData

#pragma mark - Initializers

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
    }
    return self;
}

#pragma mark - Setters

- (void) setDictionary:(NSDictionary *)dictionary
{
    NSString *farm = dictionary[@"farm"] ? : @"";
    NSString *serverId = dictionary[@"server"] ? : @"";
    NSString *id = dictionary[@"id"] ? : @"";
    NSString *secret = dictionary[@"secret"] ? : @"";
    self.imgUrl = [self buildImageUrlFromFarm:farm andServerId:serverId andId:id andSecret:secret];
    self.title = dictionary[@"title"] ? : @"";
}

-(void) setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
}

#pragma mark - Private actions

/**
 *  Builds the image url based on the parameters.
 *
 *  @param farm     farm id
 *  @param serverId server id
 *  @param id       image id
 *  @param secret   image secret
 *
 *  @return the image url
 */
-(NSString *) buildImageUrlFromFarm:(NSString *)farm andServerId:(NSString*)serverId andId:(NSString *)id andSecret:(NSString *)secret
{
    return [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farm, serverId, id, secret];
}
@end
