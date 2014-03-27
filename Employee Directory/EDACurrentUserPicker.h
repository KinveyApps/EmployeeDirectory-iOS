//
//  EDACurrentUserPicker.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/27/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EDACurrentUserPicker : NSObject

+ (instancetype)sharedPicker;

- (RACSignal *)chooseCurrentUserWithRootViewController:(UIViewController *)viewController;

@end
