//
//  AssetImageView.h
//  Photos
//
//  Created by Alexander on 28.03.16.
//  Copyright © 2016 Alexander Grebenschikov. All rights reserved.
//

@import UIKit;
@import Photos;

@interface AssetImageView : UIImageView

- (void)loadFromAsset:(PHAsset *)asset withSize:(CGSize)size square:(BOOL)square;

@end
