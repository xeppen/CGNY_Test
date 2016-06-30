//
//  CGNYSearchTermTableViewController.h
//  CGNY
//
//  Created by Sebastian Ljungberg on 30/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//
//  TableViewController to display the array of search terms.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

@interface CGNYSearchTermTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource>

@end
