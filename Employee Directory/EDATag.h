//
//  EDATag.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/18/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EDATagType) {
    EDATagTypeSupervisor,
    EDATagTypeColleague,
    EDATagTypeTeam,
    EDATagTypeNone = -1 // Tags shouldn't actually be saved with this
};

@interface EDATag : NSObject <KCSPersistable>

@property (nonatomic) NSString *taggedUsername;
@property (nonatomic) NSString *username;
@property (nonatomic) EDATagType type;
@property (nonatomic) NSString *entityID;

@property (readonly) NSString *displayName;

+ (NSString *)displayNameForType:(EDATagType)type;

@end
