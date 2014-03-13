//
//  EDAGroup.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAGroup.h"

@implementation EDAGroup

- (NSDictionary *)hostToKinveyPropertyMapping {
    return @{ @keypath(self, identifier): @"identifier",
               @keypath(self, displayName): @"displayName",
               @keypath(self, entityID): KCSEntityKeyId };
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[EDAGroup class]] == NO) return NO;
    
    EDAGroup *group = object;
    return [self.entityID isEqualToString:group.entityID];
}

- (NSUInteger)hash {
    return self.entityID.hash;
}

@end
