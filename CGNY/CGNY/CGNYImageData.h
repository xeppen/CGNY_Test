//
//  CGNYImageData.h
//  CGNY
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//
//  Data class to store image metadata
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CGNYImageData : NSObject

/**
 *  Data model parameters
 */
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;

/**
 *  Init method that takes a dictionary of json parameters to assign to data model parameters.
 *
 *  @param dictionary json dictionary
 *
 */
-(instancetype)initWithDictionary: (NSDictionary *) dictionary;

@end
