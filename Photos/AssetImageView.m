//
//  AssetImageView.h
//  Photos
//
//  Created by Alexander on 28.03.16.
//  Copyright © 2016 Alexander Grebenschikov. All rights reserved.
//

#import "AssetImageView.h"

@interface AssetImageView ()

@property (nonatomic) PHImageRequestID request;

@end

@implementation AssetImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)loadFromAsset:(PHAsset *)asset withSize:(CGSize)size {
    [[PHImageManager defaultManager] cancelImageRequest:self.request];
    
    if (!asset) {
        self.image = [UIImage imageNamed:@"EmptyAlbum"];
        return;
    }
    
    self.image = nil;
    
    __weak AssetImageView *weakSelf = self;
    self.request = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (!result || !weakSelf) {
            return;
        }
        
        weakSelf.image = result;
    }];
}

@end
