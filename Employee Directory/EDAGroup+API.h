//
//  EDAGroup+API.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAGroup.h"

@interface EDAGroup (API)

+ (KCSAppdataStore *)appdataStore;

// @return A signal which sends an array of all groups;
+ (RACSignal *)allGroups;

@end
