//
//  EDATag+API.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/18/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDATag+API.h"

#import "EDAEmployee.h"

@implementation EDATag (API)

+ (KCSAppdataStore *)appdataStore {
    KCSAppdataStore *appdataStore = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName: @"Tags",
                                                                         KCSStoreKeyCollectionTemplateClass: [EDATag class] }];
    return appdataStore;
}

+ (RACSignal *)tagForEmployee:(EDAEmployee *)employee {
    KCSQuery *query = [KCSQuery queryOnField:@"taggedUsername" withExactMatchForValue:employee.username];
    [query addQuery:[KCSQuery queryOnField:@"username" withExactMatchForValue:[KCSUser activeUser].username]];
    
    return [[[[self appdataStore] rac_queryWithQuery:query]
        map:^EDATag *(NSArray *tags) {
            if (tags.count == 0) return nil;
            else return tags.firstObject;
        }]
        take:1];
}

+ (RACSignal *)allTags {
    KCSQuery *query = [KCSQuery queryOnField:@"username" withExactMatchForValue:[KCSUser activeUser].username];
    return [[self appdataStore] rac_queryWithQuery:query];
}

@end
