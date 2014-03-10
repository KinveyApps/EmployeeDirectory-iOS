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

@interface EDALinkedInManager : NSObject

@property (nonatomic) NSString *oauthToken;

+ (instancetype)sharedManager;

- (RACSignal *)authorizeWithLinkedInWithRootViewController:(UIViewController *)viewController;

@end
