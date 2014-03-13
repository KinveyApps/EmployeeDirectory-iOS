//
//  EDAMessage+API.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/13/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAMessage+API.h"

@implementation EDAMessage (API)

+ (KCSAppdataStore *)appdataStore {
    return [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName: @"Messages",
                                                KCSStoreKeyCollectionTemplateClass: [NSDictionary class] }];
}

@end
