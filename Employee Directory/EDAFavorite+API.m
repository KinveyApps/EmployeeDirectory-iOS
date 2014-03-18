//
//  EDAFavorite+API.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/14/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAFavorite+API.h"

#import "EDAEmployee.h"

NSString * const EDAFavoriteFavoritesDidChangeNotification = @"EDAFavoriteFavoritesDidChangeNotification";

@implementation EDAFavorite (API)

+ (KCSAppdataStore *)appdataStore {
    KCSAppdataStore *appdataStore = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName: @"Favorites",
                                                                         KCSStoreKeyCollectionTemplateClass: [EDAFavorite class] }];
    return appdataStore;
}

+ (RACSignal *)favoriteForEmployee:(EDAEmployee *)employee {
    KCSQuery *query = [KCSQuery queryOnField:@"favoriteUsername" withExactMatchForValue:employee.username];
    [query addQuery:[KCSQuery queryOnField:@"username" withExactMatchForValue:[KCSUser activeUser].username]];
    
    return [[[[self appdataStore] rac_queryWithQuery:query]
        map:^EDAFavorite *(NSArray *favorites) {
            if (favorites.count == 0) return nil;
            else return favorites.firstObject;
        }]
        take:1];
}

+ (RACSignal *)createFavoriteForEmployee:(EDAEmployee *)employee {
    return [[[self favoriteForEmployee:employee]
        flattenMap:^RACStream *(EDAFavorite *favorite) {
            if (favorite) {
                return [RACSignal return:favorite];
            }
            else {
                EDAFavorite *newFavorite = [EDAFavorite new];
                newFavorite.favoriteUsername = employee.username;
                newFavorite.username = [KCSUser activeUser].username;
                
                return [[self appdataStore] rac_saveObject:newFavorite];
            }
        }]
        doNext:^(id x) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EDAFavoriteFavoritesDidChangeNotification object:nil];
        }];
}

+ (RACSignal *)deleteFavoriteForEmployee:(EDAEmployee *)employee {
    return [[[self favoriteForEmployee:employee]
        flattenMap:^RACStream *(EDAFavorite *favorite) {
            if (favorite) {
                return [[self appdataStore] rac_deleteObject:favorite];
            }
            else {
                return [RACSignal return:nil];
            }
        }]
        doNext:^(id x) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EDAFavoriteFavoritesDidChangeNotification object:nil];
        }];
}

+ (RACSignal *)allFavorites {
    KCSQuery *query = [KCSQuery queryOnField:@"username" withExactMatchForValue:[KCSUser activeUser].username];
    
    return [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:EDAFavoriteFavoritesDidChangeNotification object:nil]
        startWith:nil]
        flattenMap:^RACStream *(id value) {
            return [[self appdataStore] rac_queryWithQuery:query];
        }];
}

@end
