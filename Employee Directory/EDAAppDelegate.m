//
//  EDAAppDelegate.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAAppDelegate.h"

#import "BLAPaneController.h"
#import "EDAMenuViewController.h"
#import "EDALoginViewController.h"
#import "EDAAppearanceManager.h"
#import "EDALinkedInManager.h"
#import "EDADirectoryViewController.h"

@implementation EDAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set up window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

    [EDAAppearanceManager customizeAppearanceWithWindow:self.window];

    // Set up Kinvey
    (void) [[KCSClient sharedClient] initializeKinveyServiceForAppKey:@"kid_eTXG5Nytxq" withAppSecret:@"1512b102e63d4c44931f99d960685cdc" usingOptions:nil];

    BLAPaneController *paneController = [[BLAPaneController alloc] initWithRootViewController:[[UINavigationController alloc] initWithRootViewController:[[EDADirectoryViewController alloc] initForSearching]] sidebarViewController:[EDAMenuViewController new]];
    self.window.rootViewController = paneController;
    
    if ([KCSUser hasSavedCredentials] == NO || [KCSUser activeUser] == nil) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[EDALoginViewController new]];
        [EDAAppearanceManager customizeAppearanceOfNavigationBar:navigationController.navigationBar];
        [paneController presentViewController:navigationController animated:NO completion:NULL];
    }
    
    [[EDALinkedInManager sharedManager] startUpdating];
    
    return YES;
}

@end

