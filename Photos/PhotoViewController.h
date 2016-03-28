//
//  PhotoViewController.h
//  Photos
//
//  Created by Alexander on 25.03.16.
//  Copyright © 2016 Alexander Grebenschikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetImageView.h"

@interface PhotoViewController : UIViewController

@property (nonatomic) NSInteger index;
@property (nonatomic, strong) PHAsset *asset;

@end
