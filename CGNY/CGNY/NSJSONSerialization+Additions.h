//
//  NSJSONSerialization+Additions.h
//  CGNY
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (Additions)

+ (id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error removeKeysWithNullValue:(BOOL)removeKeysWithNullValue;

@end
