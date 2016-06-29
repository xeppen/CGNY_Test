//
//  CGNYGalleryViewController.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import "CGNYGalleryViewController.h"
#import "CGNYDataService.h"

@interface CGNYGalleryViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *data;

@end

@implementation CGNYGalleryViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize recipe image array
    self.data = [NSArray array];
    
    [self fetchImages];
}

#pragma mark - Private actions

-(void) fetchImages
{
    [CGNYDataService fetchImagesWithSearchString:@"cars" withCompletion:^(NSArray *imagesDataObjects, NSError *error) {
        if(error)
        {
            #warning Handle error
        }
        
        self.data = imagesDataObjects;
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    imageView.image = [(CGNYImageData*)[self.data objectAtIndex:indexPath.row] image];
    
    return cell;
}
@end
