//
//  CGNYImageData.h
//  CGNY
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGNYImageData : NSObject

@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *title;

-(instancetype)initWithDictionary: (NSDictionary *) dictionary;

@end
