//
//  BLAPaneController.h
//  PaneTest
//
//  Created by Ballast Lane Applications, LLC on 6/26/12.
//  Copyright (c) 2012 Electric Peel, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLAPaneController : UIViewController

@property (readonly) NSArray *viewControllers;
@property CGFloat sidebarWidthWhenVisible;
@property (readonly, getter = isSidebarVisible) BOOL sidebarVisible;

- (id)initWithRootViewController:(UIViewController *)rootViewController sidebarViewController:(UIViewController *)sidebarViewController;

- (UIViewController *)sidebarViewController;
- (UIViewController *)topViewController;
- (UIViewController *)visibleViewController;

- (void)showSidebar:(BOOL)showSidebar animated:(BOOL)animated;
- (void)presentNewRootViewController:(UIViewController *)viewController;

@end

@interface UIViewController (BLAPaneController)

@property (nonatomic, readonly) BLAPaneController *paneController;

- (void)showSidebar:(id)sender;
- (UIBarButtonItem *)sidebarItem;

@end
