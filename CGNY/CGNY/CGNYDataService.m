//
//  CGNYFlickrDataService.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import "CGNYDataService.h"
#import "NSJSONSerialization+Additions.h"

@implementation CGNYDataService


NSString *flickrBaseAPIUrl = @"https://api.flickr.com/services/rest/";

NSString *apiKey = @"94f4230615f7c654c212a96cba25dd5f";
NSInteger perPage = 20;

/**
 *  API Path : https://api.flickr.com/services/feeds/photos_public.gne
 *  Params : [
 *               "tags"     Each picture has one or multiple tags which is used as search filter.
 *               "format"   Static set to json
 *           ]
 */
+ (void) fetchImagesWithSearchString:(NSString *)search withCompletion:(void(^)(NSArray *imagesDataObjects, NSError *error))completion
{
    // If multiple words in search string, replace space with comma
    NSString *tags = [search stringByReplacingOccurrencesOfString:@" " withString:@","];
    
    // Create url with parameters
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?method=flickr.photos.search&api_key=%@&tags=%@&per_page=%li&format=json&nojsoncallback=1", flickrBaseAPIUrl, apiKey, tags, (long)perPage]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSLog(@"Fetch url: %@", url);
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return;
        }

        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError removeKeysWithNullValue:YES];
        
        // Error check if the parsing failed
        if(jsonError)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(nil, jsonError);
            });
            return;
        }

        // Error check if items is of wrong class.
        if(![json[@"photos"] isKindOfClass:[NSDictionary class]])
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(nil, [NSError errorWithDomain:@"CGNYDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Object has wrong data type" forKey:NSLocalizedDescriptionKey]]);
            });
            return;
        }

        // Error check if number of returned items is 0
        NSArray *results = json[@"photos"][@"photo"];
        if (results.count == 0) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(nil, [NSError errorWithDomain:@"CGNYDomain" code:2 userInfo:[NSDictionary dictionaryWithObject:@"Result array is empty" forKey:NSLocalizedDescriptionKey]]);
            });
            return;
        }

        // Generate imageDataObject from the response and creates an array to return
        NSMutableArray *arrayOfImageData = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in results)
        {
            CGNYImageData *newImageData = [[CGNYImageData alloc] initWithDictionary:dic];
            [arrayOfImageData addObject:newImageData];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion([[NSArray alloc] initWithArray:arrayOfImageData], nil);
        });
        return;
    }];
    [task resume];
}

/**
 *  API Path : Given by parameter input
 *  Params : [
 *               "tags"     Each picture has one or multiple tags which is used as search filter.
 *               "format"   Static set to json
 *           ]
 */
+ (void) fetchImageFromUrl:(NSString *)imgUrl withCompletion:(void(^)(UIImage *image, NSError *error))completion
{
    // Create url
    NSURL *url = [NSURL URLWithString:imgUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return;
        }
        
        // Create image from data
        UIImage *img = [[UIImage alloc] initWithData:data];
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(img, nil);
        });
        return;
    }];
    [task resume];
}
@end
