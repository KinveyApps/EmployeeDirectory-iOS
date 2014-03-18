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
    EDATagTypeTeam
};

@interface EDATag : NSObject <KCSPersistable>

@property (nonatomic) NSString *taggedUsername;
@property (nonatomic) NSString *username;
@property (nonatomic) EDATagType type;
@property (nonatomic) NSString *entityID;

+ (NSString *)displayNameForType:(EDATagType)type;

@end
