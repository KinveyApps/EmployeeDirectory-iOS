//
//  KCSReachability+RAC.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/13/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "KCSReachability+RAC.h"

@implementation KCSReachability (RAC)

- (RACSignal *)rac_reachability {
    return [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:KCSReachabilityChangedNotification object:nil]
        map:^NSNumber *(NSNotification *notification) {
            return @([notification.object isReachable]);
        }]
        startWith:@([self isReachable])];
}

@end
