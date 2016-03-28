//
//  PhotoCollectionViewCell.m
//  Photos
//
//  Created by Alexander on 25.03.16.
//  Copyright © 2016 Alexander Grebenschikov. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        AssetImageView *imageView = [[AssetImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

@end
