//
//  CGNYGalleryViewController.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import "CGNYGalleryViewController.h"
#import "CGNYDataService.h"
#import "CGNYImageCell.h"

@interface CGNYGalleryViewController () <UICollectionViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation CGNYGalleryViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register custom cell class
    //[self.collectionView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
    // Initialize recipe image array
    self.data = [NSArray array];
    [self loadSearchBar];
    [self fetchSearchedImages];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Private actions

-(void) fetchSearchedImages {
    self.data = @[];
    [self.collectionView reloadData];
    [self fetchImages];
    [self.searchBar endEditing:YES];
}

-(void) fetchImages
{
    [CGNYDataService fetchImagesWithSearchString:self.searchBar.text.length > 0 ? self.searchBar.text : @"." withCompletion:^(NSArray *imagesDataObjects, NSError *error) {
        if(error)
        {
            #warning Handle error
        }
        
        self.data = imagesDataObjects;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            return;
        });
        
    }];
}

- (void)loadSearchBar
{
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search for pictures";
//    [[UITextField appearanceWhenContainedInInstancesOfClasses:[UISearchBar class]] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    self.navigationItem.titleView = self.searchBar;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Collection items: %i", self.data.count);
    return self.data.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CGNYImageCell";
    
    CGNYImageCell *cell = (CGNYImageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.data = [self.data objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self fetchSearchedImages];
}

- (void)searchBar:(UISearchBar *)bar textDidChange:(NSString *)searchText {
    if([searchText length] == 0) {
        [self.searchBar performSelector: @selector(resignFirstResponder)
                             withObject: nil
                             afterDelay: 2.0];
    }
}

@end
