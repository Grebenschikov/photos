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
@property (nonatomic) NSInteger pointer;

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
    NSInteger pointer = ++self.pointer;
    
    if (!asset) {
        self.image = [UIImage imageNamed:@"EmptyAlbum"];
        return;
    }
    
    self.image = nil;
    __weak AssetImageView *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (!weakSelf || pointer != weakSelf.pointer) {
            return;
        }
        
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.image = result;
            });
        }];
    });
}

@end
