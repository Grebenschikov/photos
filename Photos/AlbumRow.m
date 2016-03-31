//
//  AlbumRow.m
//  Photos
//
//  Created by Alexander on 28.03.16.
//  Copyright © 2016 Alexander Grebenschikov. All rights reserved.
//

#import "AlbumRow.h"

@interface AlbumRow ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSInteger photosCount;
@property (nonatomic, strong) PHAsset *previewAsset;
@property (nonatomic, strong) PHFetchResult<PHAsset *> *photos;

@end

@implementation AlbumRow

- (instancetype)initWithTitle:(NSString *)title photos:(PHFetchResult<PHAsset *> *)photos {
    self = [super init];
    if (self) {
        self.title = title;
        self.photosCount = photos.count;
        self.previewAsset = photos.lastObject;
        self.photos = photos;
    }
    return self;
}

+ (void)fetchAllAlbums:(void (^)(NSArray<AlbumRow *> *albumsRows))completionBlock {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    });
    
    dispatch_async(queue, ^{
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        PHFetchResult *allPhotos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
        if (!allPhotos || [PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
            return dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
        
        AlbumRow *allPhotosAlbumRow = [[AlbumRow alloc] initWithTitle:NSLocalizedString(@"AllPhotos", nil) photos:allPhotos];
        NSMutableArray<AlbumRow *> *albumsRows = [[NSMutableArray alloc] initWithObjects:allPhotosAlbumRow, nil];
        PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        [albums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
            PHFetchResult<PHAsset *> *photos = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
            AlbumRow *albumRow = [[AlbumRow alloc] initWithTitle:collection.localizedTitle photos:photos];
            [albumsRows addObject: albumRow];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(albumsRows);
        });
    });
}

@end
