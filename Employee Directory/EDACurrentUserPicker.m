//
//  EDACurrentUserPicker.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/27/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDACurrentUserPicker.h"

#import "EDADirectoryViewController.h"
#import "EDAEmployee.h"
#import "EDAAppearanceManager.h"

@implementation EDACurrentUserPicker

+ (instancetype)sharedPicker {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (RACSignal *)chooseCurrentUserWithRootViewController:(UIViewController *)viewController {
    EDADirectoryViewController *directoryViewController = [[EDADirectoryViewController alloc] initForChoosingCurrentUser];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:directoryViewController];
    [EDAAppearanceManager customizeAppearanceOfNavigationBar:navigationController.navigationBar];
    
    [viewController presentViewController:navigationController animated:YES completion:NULL];
    
    return [[directoryViewController.userSelected
        flattenMap:^RACStream *(EDAEmployee *employee) {
            return [[viewController rac_dismissViewControllerAnimated:YES] mapReplace:employee];
        }]
        take:1];
}

@end
