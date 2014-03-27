//
//  EDALinkedInManager.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const EDALinkedInManagerErrorDomain;

extern NSInteger const EDALinkedInManagerErrorCodeUserRejected;
extern NSInteger const EDALinkedInManagerErrorCodeInsecure;
extern NSInteger const EDALinkedInManagerErrorCodeFailed;

@class EDAEmployee;

@interface EDALinkedInManager : NSObject

/// YES if `authorizeWithLinkedInWithRootViewController:` has already been successfully called. NO if authorization hasn't happened yet.
@property (readonly, nonatomic) BOOL canMakeRequests;

+ (instancetype)sharedManager;

/// Start updated the logged in user's LinkedIn information at appropriate times
- (void)startUpdating;

- (RACSignal *)authorizeWithLinkedInWithRootViewController:(UIViewController *)viewController;

- (RACSignal *)updateUserInfoWithLinkedInProfile:(EDAEmployee *)employee;

/// Sends an NSURL for the employee's LinkedId profile
- (RACSignal *)linkedInProfileURLForEmployee:(EDAEmployee *)employee;

@end
