//
//  UIViewController+ErrorHandling.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/11/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "UIViewController+ErrorHandling.h"

@implementation UIViewController (ErrorHandling)

- (void)handleError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedFailureReason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
