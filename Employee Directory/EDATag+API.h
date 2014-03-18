//
//  EDATag+API.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/18/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDATag.h"

extern NSString * const EDATagTagsDidChangeNotification;

@class EDAEmployee;

@interface EDATag (API)

+ (KCSAppdataStore *)appdataStore;

/// @return A signal which sends an EDATag object for the given employee, if one exists.
+ (RACSignal *)tagForEmployee:(EDAEmployee *)employee;

/// @return A signal which sends all tags for the current user.
+ (RACSignal *)allTags;

+ (RACSignal *)deleteTag:(EDATag *)tag;

+ (RACSignal *)saveTag:(EDATag *)tag;

@end
