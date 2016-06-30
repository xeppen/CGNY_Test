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
    if(_data != data){
        _data = data;
        self.imageView.image = nil;
        [self loadImage];
    }
}

#pragma mark - Private actions

/**
 *  When new data model is set, the image is fetched from the generated url and set to imageview
 */
-(void) loadImage
{
    if(self.data.image){
        [self setImage:self.data.image];
        return;
    }
    
    [self.spinner startAnimating];
    [CGNYDataService fetchImageFromUrl:self.data.imgUrl withCompletion:^(UIImage *image, NSError *error) {
        if(error)
        {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        [self.spinner stopAnimating];
        
        // Fade in image
        self.data.image = image;
        [self setImage:image];
        
    }];
}

/**
 *  Set the image to the imageview with a fade in animation
 *
 *  @param image Image to be set to imageView
 */
-(void) setImage:(UIImage*)image
{
    [self.imageView setAlpha:0.0];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.imageView setAlpha:1.0];
    [UIView commitAnimations];
    self.imageView.image = image;
}
@end
