//
//  EDAEmployee.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployee.h"

@implementation EDAEmployee

#pragma mark - Kinvey

- (NSDictionary *)hostToKinveyPropertyMapping {
    return @{ @keypath(self, username): @"username",
               @keypath(self, firstName): @"firstName",
               @keypath(self, lastName): @"lastName",
               @keypath(self, title): @"title",
               @keypath(self, division): @"division",
               @keypath(self, department): @"department",
               @keypath(self, group): @"group",
               @keypath(self, workPhone): @"workPhone",
               @keypath(self, cellPhone): @"cellPhone",
               @keypath(self, email): @"email",
               @keypath(self, supervisor): @"supervisor",
               @keypath(self, hierarchy): @"hierarchy",
               @keypath(self, entityID): KCSEntityKeyId,
               @keypath(self, headline): @"headline",
               @keypath(self, summary): @"summary",
               @keypath(self, avatarURL): @"avatarURL",
               @keypath(self, linkedInID): @"linkedInID" };
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[EDAEmployee class]] == NO) return NO;
    
    EDAEmployee *employee = object;
    return [self.entityID isEqualToString:employee.entityID];
}

- (NSUInteger)hash {
    return self.entityID.hash;
}

@end
