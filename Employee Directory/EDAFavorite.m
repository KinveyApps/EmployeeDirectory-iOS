//
//  EDAFavorite.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/14/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAFavorite.h"

@implementation EDAFavorite

- (NSDictionary *)hostToKinveyPropertyMapping {
    return @{ @keypath(self, favoriteUsername): @"favoriteUsername",
               @keypath(self, favoriteUserSearchName): @"favoriteUserSearchName",
               @keypath(self, username): @"username",
               @keypath(self, entityID): KCSEntityKeyId };
}

@end
