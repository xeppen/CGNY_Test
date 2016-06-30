//
//  CGNYImageDisplayViewController.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 30/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import "CGNYImageDisplayViewController.h"

@interface CGNYImageDisplayViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CGNYImageDisplayViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.frame = self.view.frame;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    self.imageView.image = self.data.image;
    self.imageView.frame = self.view.frame;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.imageView];
    
    self.navigationItem.title = self.data.title;
}

#pragma mark - Setter

-(void)setData:(CGNYImageData *)data
{
    _data = data;
}

#pragma mark - UIScrollViewDelegate

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
@end
