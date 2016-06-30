//
//  CGNYImageDisplayViewController.h
//  CGNY
//
//  Created by Sebastian Ljungberg on 30/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGNYImageData.h"

@interface CGNYImageDisplayViewController : UIViewController

@property (nonatomic, strong) CGNYImageData *data;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end
