//
//  KCSReachability+RAC.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/13/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <KinveyKit/KinveyKit.h>

@interface KCSReachability (RAC)

- (RACSignal *)rac_reachability;

@end
