//
//  AlbumsTableViewController.m
//  Photos
//
//  Created by Alexander on 25.03.16.
//  Copyright © 2016 Alexander Grebenschikov. All rights reserved.
//

@import Photos;

#import "AlbumsTableViewController.h"
#import "AlbumTableViewCell.h"
#import "PhotosCollectionViewController.h"
#import "AlbumRow.h"

@interface AlbumsTableViewController () <UITableViewDelegate, UITableViewDataSource, PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, strong) UIActivityIndicatorView *footerActivityIndicator;
@property (nonatomic, strong) NSArray<AlbumRow *> *albumRows;

@end

@implementation AlbumsTableViewController

static NSString * const AlbumCellIdentifier = @"albumCell";

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)loadView {
    [super loadView];
    
    self.navigationItem.title = NSLocalizedString(@"AlbumsTitle", nil);
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[AlbumTableViewCell class] forCellReuseIdentifier:AlbumCellIdentifier];
    
    CGRect footerRect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30);
    UIView *footerView = [[UIView alloc] initWithFrame:footerRect];
    
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:footerRect];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.font = [UIFont systemFontOfSize:13];
    self.footerLabel = footerLabel;
    [footerView addSubview:footerLabel];
    
    UIActivityIndicatorView *footerActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    footerActivityIndicator.hidesWhenStopped = YES;
    [footerActivityIndicator startAnimating];
    footerActivityIndicator.frame = footerRect;
    self.footerActivityIndicator = footerActivityIndicator;
    [footerView addSubview:footerActivityIndicator];

    tableView.tableFooterView = footerView;
    
    self.tableView = tableView;
    self.view = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAlbums:^{
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }];
}

- (void)loadAlbums:(void (^)(void))completionBlock {
    [self setFooterText: nil];
    __weak AlbumsTableViewController *weakSelf = self;
    [AlbumRow fetchAllAlbums:^(NSArray<AlbumRow *> *albumsRows) {
        if (!weakSelf) {
            return;
        }
        
        if (albumsRows == nil) {
            [self setFooterText:NSLocalizedString(@"NoAccess", nil)];
        } else {
            [self setFooterText: @""];
        }
        
        weakSelf.albumRows = albumsRows;
        [weakSelf.tableView reloadData];
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)setFooterText:(NSString *)text {
    if (!text) {
        [self.footerActivityIndicator startAnimating];
    } else {
        [self.footerActivityIndicator stopAnimating];
        self.footerLabel.text = text;
    }
    
    self.footerLabel.hidden = text == nil;
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    [self loadAlbums:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumRows == nil ? 0 : self.albumRows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:AlbumCellIdentifier forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(AlbumTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setRow:[self.albumRows objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PhotosCollectionViewController *photosViewController = [[PhotosCollectionViewController alloc] init];
    photosViewController.album = [self.albumRows objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:photosViewController animated:YES];
}


@end
