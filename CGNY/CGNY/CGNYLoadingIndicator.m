//
//  CGNYLoadingIndicator.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 29/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import "CGNYLoadingIndicator.h"

@interface CGNYLoadingIndicator ()

@property (nonatomic, strong) UILabel *loadingLabel;

@end

@implementation CGNYLoadingIndicator

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Private actions

- (void) setup
{
    self.activityView = [[UIActivityIndicatorView alloc] init];
    self.loadingLabel = [[UILabel alloc] init];
    
    self.loadingLabel.text = @"Fetching images...";
    
    self.loadingLabel.backgroundColor = [UIColor greenColor];
    
    // Set sizes
    self.activityView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    self.loadingLabel.frame = CGRectMake(self.frame.size.height, 0, self.frame.size.width-self.frame.size.height, self.frame.size.height);
    
    [self addSubview:self.activityView];
    [self addSubview:self.loadingLabel];
}

@end
