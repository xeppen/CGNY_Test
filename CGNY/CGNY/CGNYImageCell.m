//
//  CGNYImageCell.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 29/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import "CGNYImageCell.h"
#import "CGNYDataService.h"

@implementation CGNYImageCell

#pragma mark - Setter

-(void)setData:(CGNYImageData *)data
{
    _data = data;

    [self loadImage];
}

#pragma mark - Private actions

-(void) loadImage
{
    // Show spinner
    [CGNYDataService fetchImageFromUrl:self.data.imgUrl withCompletion:^(UIImage *image, NSError *error) {
        if(error)
        {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        self.data.image = image;
        // Animation
        self.imageView.image = image;
        
        // Stop spinner
        // Reload cell
    }];
}
@end
