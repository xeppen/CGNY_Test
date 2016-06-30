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
#import "UIView+Toast.h"
#import "UIScrollView+EmptyDataSet.h"

@interface CGNYGalleryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation CGNYGalleryViewController

NSString *searchArrayIdentifier = @"CGNYSearchArray";

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set datasource for
    self.collectionView.emptyDataSetSource = self;
    
    // Initialize recipe image array
    self.data = [NSArray array];
    [self loadSearchBar];
    [self fetchSearchedImages];
    
    // Add no photos image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"no_images"]];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Private actions

/**
 *  Uses the search text to fetch new images
 */
-(void) fetchSearchedImages {
    self.data = @[];
    [self.collectionView reloadData];
    [self saveSearchString];
    [self fetchImages];
    [self.searchBar endEditing:YES];
}

/**
 *  Give the data service order to fetch images
 */
-(void) fetchImages
{
    [CGNYDataService fetchImagesWithSearchString:self.searchBar.text.length > 0 ? self.searchBar.text : @"." withCompletion:^(NSArray *imagesDataObjects, NSError *error) {
        if(error)
        {
            // Show error
            [self.view makeToast:@"There is an error fetching photo data!"
                        duration:2.0
                        position:CSToastPositionBottom
                           style:[[CSToastStyle alloc] initWithDefaultStyle]];
        }
        
        if(imagesDataObjects.count == 0)
        {
            [self.view makeToast:@"There are no pictures that match that search term!"
                        duration:2.0
                        position:CSToastPositionBottom
                           style:[[CSToastStyle alloc] initWithDefaultStyle]];
        }
        
        self.data = imagesDataObjects;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            return;
        });
        
    }];
}

/**
 *  Load a UISearchBar and do minor configurations
 */
- (void)loadSearchBar
{
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search for pictures";
    self.navigationItem.titleView = self.searchBar;
}

/**
 *  Make a transition to the view controller to display a bigger version. Also sets the data model to the view controller.
 *
 *  @param segue  transition segues
 *  @param sender collection view origin cell
 */
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

/**
 *  Store the search string in NSUserDefaults
 */
-(void) saveSearchString
{
    NSString *searchString = self.searchBar.text;
    
    // Check if empty search is done.
    if(searchString.length == 0)
        return;
    
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
        [self fetchSearchedImages];
    }
}

#pragma mark - DZNEmptyDataSetSource

-(UIImage *) imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_images"];
}

@end
