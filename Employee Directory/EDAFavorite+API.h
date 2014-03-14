//
//  EDAFavorite+API.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/14/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAFavorite.h"

extern NSString * const EDAFavoriteFavoritesDidChangeNotification;

@class EDAEmployee;

@interface EDAFavorite (API)

+ (KCSAppdataStore *)appdataStore;

/// @return A signal which sends an EDAFavorite object for the given employee, if one exists.
+ (RACSignal *)favoriteForEmployee:(EDAEmployee *)employee;

/// @return A signal which sends a new EDAFavorite object for the given employee.
+ (RACSignal *)createFavoriteForEmployee:(EDAEmployee *)employee;

/// @return A signal which deletes the EDAFavorite objects for the given employee.
+ (RACSignal *)deleteFavoriteForEmployee:(EDAEmployee *)employee;

/// @return A signal which sends all favorites for the current user.
+ (RACSignal *)allFavorites;

@end
