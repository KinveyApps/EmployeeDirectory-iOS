//
//  EDAEmployee+API.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployee+API.h"

#import "EDAGroup.h"
#import "EDAImageManager.h"

NSString * const EDAEmployeeErrorDomain = @"com.ballastlane.employeedirectory.employee";

NSInteger const EDAEmployeeErrorCodeUserNotFound = 1;

@implementation EDAEmployee (API)

+ (KCSAppdataStore *)appdataStore {
    KCSCachedStore *cachedStore = [KCSCachedStore storeWithOptions:@{ KCSStoreKeyCollectionName: @"contacts",
                                                                      KCSStoreKeyCollectionTemplateClass: [EDAEmployee class],
                                                                      KCSStoreKeyCachePolicy: @(KCSCachePolicyNetworkFirst) }];
    [cachedStore setCachePolicy:KCSCachePolicyBoth];
    
    return cachedStore;
}

+ (KCSAppdataStore *)appdataStoreForSearching {
    KCSAppdataStore *appdataStore = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName: @"contacts",
                                                                         KCSStoreKeyCollectionTemplateClass: [EDAEmployee class] }];
    return appdataStore;
}

+ (RACSignal *)allEmployees {
    return [[self appdataStore] rac_queryWithQuery:[KCSQuery query]];
}

+ (RACSignal *)employeeWithUsername:(NSString *)username {
    KCSQuery *query = [KCSQuery queryOnField:@"_id" withExactMatchForValue:username];
    return [[[self appdataStore] rac_queryWithQuery:query]
        flattenMap:^RACStream *(NSArray *users) {
            if (users.count == 0) {
                NSError *error = [NSError errorWithDomain:EDAEmployeeErrorDomain code:EDAEmployeeErrorCodeUserNotFound userInfo:@{ NSLocalizedDescriptionKey: @"No matching users found" }];
                return [RACSignal error:error];
            }
            else {
                return [RACSignal return:users.firstObject];
            }
        }];
}

+ (RACSignal *)directReportsOfEmployee:(EDAEmployee *)employee {
    return [RACSignal return:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"hierarchy" withRegex:[NSString stringWithFormat:@"^%@.", employee.hierarchy]];
    return [[self appdataStore] rac_queryWithQuery:query];
}

+ (RACSignal *)employeesInGroup:(EDAGroup *)group {
    return [RACSignal return:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"hierarchy" withRegex:[NSString stringWithFormat:@"^%@", group.identifier]];
    return [[self appdataStore] rac_queryWithQuery:query];
}

+ (RACSignal *)employeesWithUsernames:(NSArray *)usernames {
    if (usernames.count == 0) return [RACSignal return:@[]];
    
    KCSQuery *query = [usernames.rac_sequence foldLeftWithStart:nil reduce:^KCSQuery *(KCSQuery *accumulator, NSString *username){
        KCSQuery *queryForUsername = [KCSQuery queryOnField:@"_id" withExactMatchForValue:username];
        
        if (accumulator == nil) {
            return queryForUsername;
        }
        else {
            return [accumulator queryByJoiningQuery:queryForUsername usingOperator:kKCSOr];
        }
    }];
    
    return [[self appdataStore] rac_queryWithQuery:query];
}

+ (RACSignal *)employeesMatchingSearchString:(NSString *)searchString {
    return [[self appdataStoreForSearching] rac_queryWithQuery:[KCSQuery queryOnField:@"name" withExactMatchForValue:searchString]];
}

@end
