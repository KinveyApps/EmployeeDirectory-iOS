//
//  EDAEmployee.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployee.h"

@interface EDAEmployee ()

@property (nonatomic) NSDictionary *addressDictionary;

@end

@implementation EDAEmployee

#pragma mark - Kinvey

- (id)init {
    self = [super init];
    if (self == nil) return nil;
    
    RAC(self, username) = RACObserve(self, entityID);
    
    RACSignal *addressSignal = [RACObserve(self, addressDictionary)
        map:^NSDictionary *(id value) {
            if ([value isKindOfClass:[NSDictionary class]]) return value;
            else return nil;
        }];
    RAC(self, address) = [[addressSignal
        map:^NSString *(NSDictionary *dictionary) {
            return dictionary[@"Street"];
        }]
        filter:^BOOL(id value) {
            return [value isKindOfClass:[NSNull class]] == NO;
        }];
    RAC(self, city) = [[addressSignal
        map:^NSString *(NSDictionary *dictionary) {
            return dictionary[@"City"];
        }]
        filter:^BOOL(id value) {
            return [value isKindOfClass:[NSNull class]] == NO;
        }];
    
    RAC(self, state) = [[addressSignal
        map:^NSString *(NSDictionary *dictionary) {
            return dictionary[@"State"];
        }]
        filter:^BOOL(id value) {
            return [value isKindOfClass:[NSNull class]] == NO;
        }];
    RAC(self, zipCode) = [[addressSignal
        map:^NSString *(NSDictionary *dictionary) {
            return dictionary[@"PostalCode"];
        }]
        filter:^BOOL(id value) {
            return [value isKindOfClass:[NSNull class]] == NO;
        }];
    return self;
}

- (NSDictionary *)hostToKinveyPropertyMapping {
    return @{  @keypath(self, firstName): @"FirstName",
               @keypath(self, lastName): @"LastName",
               @keypath(self, title): @"JobTitle",
               @keypath(self, division): @"division",
               @keypath(self, department): @"Department",
               @keypath(self, group): @"group",
               @keypath(self, workPhone): @"BusinessPhone",
               @keypath(self, cellPhone): @"MobilePhone",
               @keypath(self, email): @"email",
               @keypath(self, addressDictionary): @"Address",
               @keypath(self, entityID): KCSEntityKeyId };
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
