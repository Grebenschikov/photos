//
//  ViewerViewController.m
//  Photos
//
//  Created by Alexander on 25.03.16.
//  Copyright © 2016 Alexander Grebenschikov. All rights reserved.
//

#import "ViewerViewController.h"
#import "PhotoViewController.h"

@interface ViewerViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation ViewerViewController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.delegate = self;
    self.dataSource = self;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:gesture];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PhotoViewController *startController = [self controllerAtIndex:self.index];
    [self setViewControllers:@[startController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self writeTitleIndex:self.index];
}

- (void)tapAction {
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

- (void)writeTitleIndex:(NSInteger)index {
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"ViewerTitle", nil), index + 1, self.album.photosCount];
}

- (PhotoViewController *)controllerAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.album.photosCount) {
        return nil;
    }
    
    PhotoViewController *photoController = [[PhotoViewController alloc] init];
    photoController.asset = [self.album.photos objectAtIndex:index];
    photoController.index = index;
    return photoController;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger currentIndex = ((PhotoViewController *)pageViewController.viewControllers.firstObject).index;
    return [self controllerAtIndex:currentIndex - 1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger currentIndex = ((PhotoViewController *)pageViewController.viewControllers.firstObject).index;
    return [self controllerAtIndex:currentIndex + 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSInteger currentIndex = ((PhotoViewController *)pageViewController.viewControllers.firstObject).index;
    [self writeTitleIndex:currentIndex];
}

@end
