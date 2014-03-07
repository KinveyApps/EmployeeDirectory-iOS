//
//  KCSUser+RAC.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <KinveyKit/KinveyKit.h>

@interface KCSUser (RAC)

/// @return A signal which sends a `KCSUser` object when login is successful.
+ (RACSignal *)rac_loginWithUsername:(NSString *)username password:(NSString *)password;

@end
