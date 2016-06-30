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

@interface CGNYGalleryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation CGNYGalleryViewController

NSString *searchArrayIdentifier = @"CYGNSearchArray";

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
    [self saveSearchString];
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
    self.navigationItem.titleView = self.searchBar;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[CGNYImageCell class]]) {
        if ([segue.identifier isEqualToString:@"CGNYImageViewSegue"]) {
            if ([segue.destinationViewController respondsToSelector:@selector(setData:)]) {
                [segue.destinationViewController performSelector:@selector(setData:)
                                                      withObject:[(CGNYImageCell*)sender data]];
            }
        }
    }
}

-(void) saveSearchString
{
    NSString *searchString = self.searchBar.text;
    
    // Read
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *searchTermArray = [defaults objectForKey:searchArrayIdentifier];
    
    // Make mutable copy
    NSMutableArray *mutableSearchTermArray = [searchTermArray mutableCopy];
    [mutableSearchTermArray addObject:searchString];
    
    // Save
    [defaults setObject:[[NSArray alloc] initWithArray:mutableSearchTermArray] forKey:searchArrayIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Collection items: %lu", (unsigned long)self.data.count);
    return self.data.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CGNYImageCell";
    
    CGNYImageCell *cell = (CGNYImageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.data = [self.data objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //retrieve image from your array
    //push new view controller/perform segue with image
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
