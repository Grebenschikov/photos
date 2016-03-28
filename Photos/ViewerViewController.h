//
//  ViewerViewController.h
//  Photos
//
//  Created by Alexander on 25.03.16.
//  Copyright © 2016 Alexander Grebenschikov. All rights reserved.
//

@import UIKit;
#import "AlbumRow.h"

@interface ViewerViewController : UIPageViewController

@property (nonatomic, strong) AlbumRow *album;
@property (nonatomic) NSInteger index;

@end
