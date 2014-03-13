//
//  EDAMessage.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/13/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAMessage.h"

@implementation EDAMessage

- (NSDictionary *)hostToKinveyPropertyMapping {
    return @{ @keypath(self, recipientPhoneNumber): @"recipient",
               @keypath(self, message): @"message",
               @keypath(self, entityID): KCSEntityKeyId };
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[EDAMessage class]] == NO) return NO;
    
    EDAMessage *message = object;
    return [self.entityID isEqualToString:message.entityID];
}

- (NSUInteger)hash {
    return self.entityID.hash;
}

@end
