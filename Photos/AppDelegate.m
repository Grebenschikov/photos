//
//  AppDelegate.m
//  Photos
//
//  Created by Alexander on 25.03.16.
//  Copyright © 2016 Alexander Grebenschikov. All rights reserved.
//

#import "AppDelegate.h"
#import "AlbumsTableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    AlbumsTableViewController *albumsViewController = [[AlbumsTableViewController alloc] init];
    UINavigationController *mainViewController = [[UINavigationController alloc] initWithRootViewController:albumsViewController];
    [window setRootViewController:mainViewController];
    [window makeKeyAndVisible];
    self.window = window;
    return YES;
}

@end
