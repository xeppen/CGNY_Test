//
//  FirstViewController.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import "FirstViewController.h"
#import "CGNYDataService.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [CGNYDataService fetchImagesWithSearchString:@"cars" withCompletion:^(NSArray *imagesDataObjects, NSError *error) {
        NSLog(@"Lengt of array: %lu", (unsigned long)imagesDataObjects.count);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
