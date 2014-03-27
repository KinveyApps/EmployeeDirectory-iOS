//
//  UIViewController+RAC.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/25/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RAC)

- (RACSignal *)rac_dismissViewControllerAnimated:(BOOL)animated;
- (RACSignal *)rac_presentViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end