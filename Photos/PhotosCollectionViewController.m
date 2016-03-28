//
//  PhotosCollectionViewController.m
//  Photos
//
//  Created by Alexander on 25.03.16.
//  Copyright © 2016 Alexander Grebenschikov. All rights reserved.
//

#import "PhotosCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "ViewerViewController.h"

@interface PhotosCollectionViewController ()  <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PhotosCollectionViewController

static NSString * const PhotoCellIdenitifier = @"photoCell";

- (void)loadView {
    [super loadView];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(80, 80);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:PhotoCellIdenitifier];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    self.collectionView = collectionView;
    self.view = collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.album.title;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.album.photosCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   return [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdenitifier forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(PhotoCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell.imageView loadFromAsset:[self.album.photos objectAtIndex:indexPath.row] withSize:CGSizeMake(80, 80)];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ViewerViewController *viewerController = [[ViewerViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    viewerController.album = self.album;
    viewerController.index = indexPath.row;
    [self.navigationController pushViewController:viewerController animated:YES];
}

@end
