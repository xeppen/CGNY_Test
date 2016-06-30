//
//  CGNYImageDisplayViewController.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 30/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import "CGNYImageDisplayViewController.h"

@interface CGNYImageDisplayViewController () <UIScrollViewDelegate>

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
    
    self.imageView.image = self.data.image;
    
    self.navigationItem.title = self.data.title;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.imageView.center = CGPointMake(self.imageView.center.x, self.imageView.center.y - self.tabBarController.tabBar.frame.size.height - self.navigationController.navigationBar.frame.size.height - 30);
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
