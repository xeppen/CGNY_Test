//
//  CGNYSearchTermTableViewController.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 30/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import "CGNYSearchTermTableViewController.h"
#import "UIView+Toast.h"

@interface CGNYSearchTermTableViewController ()

@property (nonatomic, strong) NSArray *searchTerms;
@end

@implementation CGNYSearchTermTableViewController

#pragma mark - Initialization

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Past search terms";
    
    // Set DZNEmptyDataSetSource
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Add navigation bar button
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearSearchTermArray)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Fetch search term array
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.searchTerms = [defaults objectForKey:@"CGNYSearchArray"] ? : @[];
    [self.tableView reloadData];
}

#pragma mark - Private actions

-(void) clearSearchTermArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@[] forKey:@"CGNYSearchArray"];
    self.searchTerms = @[];
    [self.tableView reloadData];
    
    // Display msg to user
    [self.view makeToast:@"Past search terms have been cleared."
                duration:2.0
                position:CSToastPositionTop];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchTerms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [self.searchTerms objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - DZNEmptyDataSetSource

-(UIImage *) imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_search_terms"];
}
@end
