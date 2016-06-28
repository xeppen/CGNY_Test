//
//  CGNYFlickrDataService.h
//  CGNY
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGNYDataService : NSObject

/**
 * Fetches public pictures from Flickr API filtered by a search string on tags
 *
 * @param search     Search string that filters on tags.
 * @param completion Block that is called when pictures have been fetched and parsed into picture data objects.
 */
+ (void) fetchImagesWithSearchString:(NSString *)search withCompletion:(void(^)(NSArray *imagesDataObjects, NSError *error))completion;

@end
