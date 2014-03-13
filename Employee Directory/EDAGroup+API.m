//
//  EDAGroup+API.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAGroup+API.h"

@implementation EDAGroup (API)

+ (KCSAppdataStore *)appdataStore {
    return [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName: @"Groups",
                                                KCSStoreKeyCollectionTemplateClass: [EDAGroup class] }];
}

+ (RACSignal *)allGroups {
    return [[self appdataStore] rac_queryWithQuery:[KCSQuery query]];
}

@end
