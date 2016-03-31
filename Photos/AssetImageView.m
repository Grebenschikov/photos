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

    NSString *cacheKey = [NSString stringWithFormat:@"%@_%f_%f", asset.localIdentifier, size.height, size.width];
    UIImage *image = [[AssetImageView cacher] objectForKey:cacheKey];
    if (image) {
        self.image = image;
        return;
    }
        
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    if (square) {
        options.synchronous = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        CGFloat minSide = MIN(asset.pixelWidth, asset.pixelHeight);
        CGFloat width = minSide / asset.pixelWidth;
        CGFloat height = minSide / asset.pixelHeight;
        options.normalizedCropRect = CGRectMake((1 - width) / 2, (1 - height) / 2, width, height);
    } else {
        CGFloat scale = [UIScreen mainScreen].scale ;
        size = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scale, scale));
    }

    __weak AssetImageView *weakSelf = self;
    self.request = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result && square) {
            [[AssetImageView cacher] setObject:result forKey:cacheKey];
        }
        
        if (weakSelf) {
            weakSelf.image = result;
        }
    }];
}

+ (NSCache *)cacher {
    static NSCache *cacher;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacher = [[NSCache alloc] init];
        [cacher setCountLimit:5000];
    });
    
    return cacher;
}

@end
