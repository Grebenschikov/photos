//
//  AlbumTableViewCell.m
//  Photos
//
//  Created by Alexander on 25.03.16.
//  Copyright © 2016 Alexander Grebenschikov. All rights reserved.
//

#import "AlbumTableViewCell.h"
#import "AssetImageView.h"

@interface AlbumTableViewCell ()

@property (nonatomic, strong) AssetImageView *albumPreviewImageView;
@property (nonatomic, strong) UILabel *albumTitleLabel;
@property (nonatomic, strong) UILabel *photosCountLabel;

@end

@implementation AlbumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        AssetImageView *albumPreviewImageView = [[AssetImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        [self addSubview:albumPreviewImageView];
        
        UILabel *albumTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        albumTitleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:albumTitleLabel];
        
        UILabel *photosCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        photosCountLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:photosCountLabel];
        
        self.albumPreviewImageView = albumPreviewImageView;
        self.albumTitleLabel = albumTitleLabel;
        self.photosCountLabel = photosCountLabel;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat labelWidth = CGRectGetWidth(self.frame) - 100 - 35;
    self.albumTitleLabel.frame = CGRectMake(100, 30, labelWidth, 20);
    self.photosCountLabel.frame = CGRectMake(100, 55, labelWidth, 20);
}

- (void)setRow:(AlbumRow *)row {
    self.albumTitleLabel.text = row.title;
    self.photosCountLabel.text = [NSString stringWithFormat:@"%d", row.photosCount];
    
    [self.albumPreviewImageView loadFromAsset:row.previewAsset withSize:self.albumPreviewImageView.frame.size];
}

@end
