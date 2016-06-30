//
//  CGNYImageCell.h
//  CGNY
//
//  Created by Sebastian Ljungberg on 29/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGNYImageData.h"

@interface CGNYImageCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) CGNYImageData *data;

@end
