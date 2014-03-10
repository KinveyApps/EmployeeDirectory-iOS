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
#import "EDAEmployeeDetailViewController.h"

@implementation EDAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set up window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    EDAEmployeeDetailViewController *viewController = [[EDAEmployeeDetailViewController alloc] init];
    BLAPaneController *paneController = [[BLAPaneController alloc] initWithRootViewController:[UIViewController new] sidebarViewController:[EDAMenuViewController new]];
    self.window.rootViewController = viewController;
    [paneController showSidebar:YES animated:NO];
    
    [paneController presentViewController:[[UINavigationController alloc] initWithRootViewController:[EDALoginViewController new]] animated:NO completion:NULL];
    
    // Set up Kinvey
    (void) [[KCSClient sharedClient] initializeKinveyServiceForAppKey:@"kid_eTXG5Nytxq" withAppSecret:@"1512b102e63d4c44931f99d960685cdc" usingOptions:nil];
    
    return YES;
}

@end

