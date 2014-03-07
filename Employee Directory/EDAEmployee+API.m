//
//  EDAEmployee+API.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployee+API.h"

@implementation EDAEmployee (API)

+ (KCSAppdataStore *)appdataStore {
    return [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName: @"Employees",
                                                KCSStoreKeyCollectionTemplateClass: [EDAEmployee class] }];
}

+ (RACSignal *)allEmployees {
    return [[self appdataStore] rac_queryWithQuery:[KCSQuery query]];
}

@end
