//
//  EDATag.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/18/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDATag.h"

@implementation EDATag

- (NSDictionary *)hostToKinveyPropertyMapping {
    return @{ @keypath(self, taggedUsername): @"taggedUsername",
               @keypath(self, username): @"username",
               @keypath(self, type): @"type",
               @keypath(self, entityID): KCSEntityKeyId };
}

+ (NSString *)displayNameForType:(EDATagType)type {
    switch (type) {
        case EDATagTypeTeam:
            return @"Team";
            break;
        case EDATagTypeSupervisor:
            return @"Supervisor";
            break;
        case EDATagTypeColleague:
            return @"Colleague";
            break;
        default:
            return nil;
    }
}

@end
