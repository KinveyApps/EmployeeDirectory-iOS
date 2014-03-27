//
//  EDACitrixManager.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/25/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EDACitrixManager : NSObject

@property (readonly, nonatomic) NSString *oauthToken;

+ (instancetype)sharedManager;

- (RACSignal *)authorizeWithCitrixWithRootViewController:(UIViewController *)viewController;

@end
