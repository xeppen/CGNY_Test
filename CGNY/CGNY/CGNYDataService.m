//
//  CGNYFlickrDataService.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import "CGNYDataService.h"
#import "NSJSONSerialization+Additions.h"
#import "CGNYImageData.h"

@implementation CGNYDataService


NSString *flickrBaseAPIUrl = @"https://api.flickr.com/services/feeds/photos_public.gne";

/**
 *  API Path : https://api.flickr.com/services/feeds/photos_public.gne
 *  Params : [
 *               "tags"     Each picture has one or multiple tags which is used as search filter.
 *               "format"   Static set to json
 *           ]
 */
+ (void) fetchImagesWithSearchString:(NSString *)search withCompletion:(void(^)(NSArray *imagesDataObjects, NSError *error))completion
{
    // Create url with parameters
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?format=json&nojsoncallback=1&tags=%@", flickrBaseAPIUrl, search]];
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
        if(![json[@"items"] isKindOfClass:[NSArray class]])
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(nil, [NSError errorWithDomain:@"CGNYDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Object has wrong data type" forKey:NSLocalizedDescriptionKey]]);
            });
            return;
        }

        // Error check if number of returned items is 0
        NSArray *results = json[@"items"];
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
    
    NSLog(@"Image fetch url: %@", url);
    
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
