//
//  EDAEmployeeInfo.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/27/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployeeInfo.h"

@implementation EDAEmployeeInfo

- (NSDictionary *)hostToKinveyPropertyMapping {
    return @{ @keypath(self, userID): @"userID",
               @keypath(self, headline): @"headline",
               @keypath(self, summary): @"summary",
               @keypath(self, avatarURL): @"avatarURL",
               @keypath(self, linkedInID): @"linkedInID",
               @keypath(self, entityID): KCSEntityKeyId };
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[EDAEmployeeInfo class]] == NO) return NO;
    
    EDAEmployeeInfo *employeeInfo = object;
    return [self.entityID isEqualToString:employeeInfo.entityID];
}

- (NSUInteger)hash {
    return self.entityID.hash;
}

@end
