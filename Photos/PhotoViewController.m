//
//  PhotoViewController.m
//  Photos
//
//  Created by Alexander on 25.03.16.
//  Copyright © 2016 Alexander Grebenschikov. All rights reserved.
//

#import "PhotoViewController.h"

@implementation PhotoViewController

-(void)loadView {
    [super loadView];
    
    AssetImageView *imageView = [[AssetImageView alloc] initWithFrame:self.view.frame];
    [imageView loadFromAsset:self.asset withSize:self.view.frame.size square:NO];
    self.view = imageView;
}

@end
