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

- (void)loadFromAsset:(PHAsset *)asset withSize:(CGSize)size square:(BOOL)square {
    [[PHImageManager defaultManager] cancelImageRequest:self.request];
    
    if (!asset) {
        self.image = [UIImage imageNamed:@"EmptyAlbum"];
        return;
    }
    
    __weak AssetImageView *weakSelf = self;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize realSize = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scale, scale));
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    if (square) {
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        CGFloat minSide = MIN(asset.pixelWidth, asset.pixelHeight);
        CGFloat width = minSide / asset.pixelWidth;
        CGFloat height = minSide / asset.pixelHeight;
        options.normalizedCropRect = CGRectMake((1 - width) / 2, (1 - height) / 2, width, height);
    }
    
    self.request = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:realSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (!result || !weakSelf) {
            return;
        }
        
        weakSelf.image = result;
    }];
}

@end
