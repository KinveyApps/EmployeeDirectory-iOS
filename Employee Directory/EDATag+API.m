//
//  EDATag+API.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/18/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDATag+API.h"

#import "EDAEmployee.h"

NSString * const EDATagTagsDidChangeNotification = @"EDATagTagsDidChangeNotification";

@implementation EDATag (API)

+ (KCSAppdataStore *)appdataStore {
    KCSAppdataStore *appdataStore = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName: @"Tags",
                                                                         KCSStoreKeyCollectionTemplateClass: [EDATag class] }];
    return appdataStore;
}

+ (RACSignal *)tagForEmployee:(EDAEmployee *)employee {
    KCSQuery *query = [KCSQuery queryOnField:@"taggedUsername" withExactMatchForValue:employee.username];
    [query addQuery:[KCSQuery queryOnField:@"username" withExactMatchForValue:[KCSUser activeUser].username]];
    
    return [[[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:EDATagTagsDidChangeNotification object:nil]
        startWith:nil]
        flattenMap:^RACStream *(id value) {
            return [[self appdataStore] rac_queryWithQuery:query];
        }]
        map:^EDATag *(NSArray *tags) {
            if (tags.count == 0) return nil;
            else return tags.firstObject;
        }]
        take:1];
}

+ (RACSignal *)allTags {
    KCSQuery *query = [KCSQuery queryOnField:@"username" withExactMatchForValue:[KCSUser activeUser].username];
    
    return [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:EDATagTagsDidChangeNotification object:nil]
        startWith:nil]
        flattenMap:^RACStream *(id value) {
            return [[self appdataStore] rac_queryWithQuery:query];
        }];
}

+ (RACSignal *)deleteTag:(EDATag *)tag {
    return [[[self appdataStore] rac_deleteObject:tag]
        doNext:^(id x) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EDATagTagsDidChangeNotification object:nil];
        }];
}

+ (RACSignal *)saveTag:(EDATag *)tag {
    return [[[self appdataStore] rac_saveObject:tag]
        doNext:^(id x) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EDATagTagsDidChangeNotification object:nil];
        }];
}

@end
