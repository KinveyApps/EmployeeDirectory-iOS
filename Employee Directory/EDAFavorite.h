//
//  EDAFavorite.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/14/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EDAFavorite : NSObject <KCSPersistable>

@property (nonatomic) NSString *favoriteUsername;
@property (nonatomic) NSString *favoriteUserSearchName;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *entityID;

@end
