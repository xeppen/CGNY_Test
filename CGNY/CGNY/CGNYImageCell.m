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
    if(!self.data.image){
        __block UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.contentView addSubview:spinner];
        spinner.center = self.center;
        spinner.hidesWhenStopped = TRUE;
        spinner.hidden = NO;
        [spinner startAnimating];
        [CGNYDataService fetchImageFromUrl:self.data.imgUrl withCompletion:^(UIImage *image, NSError *error) {
            [spinner stopAnimating];
            if(error)
            {
                NSLog(@"Error: %@", error.localizedDescription);
                return;
            }
            self.data.image = image;
            [self.imageView setAlpha:0.0];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [self.imageView setAlpha:1.0];
            [UIView commitAnimations];
            self.imageView.image = image;
            
            // Stop spinner
            // Reload cell
        }];
    }
}
@end
