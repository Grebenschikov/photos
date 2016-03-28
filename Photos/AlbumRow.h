//
//  AlbumRow.h
//  Photos
//
//  Created by Alexander on 28.03.16.
//  Copyright © 2016 Alexander Grebenschikov. All rights reserved.
//

@import Photos;

@interface AlbumRow : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, readonly) NSInteger photosCount;
@property (nonatomic, strong, readonly) PHAsset *previewAsset;
@property (nonatomic, strong, readonly) PHFetchResult<PHAsset *> *photos;

+ (void)fetchAllAlbums:(void (^)(NSArray<AlbumRow *> *albumsRows))completionBlock;

@end
