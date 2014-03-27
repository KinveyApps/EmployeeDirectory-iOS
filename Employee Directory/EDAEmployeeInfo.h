//
//  EDAEmployeeInfo.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/27/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EDAEmployeeInfo : NSObject <KCSPersistable>

@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *headline;
@property (nonatomic) NSString *summary;
@property (nonatomic) NSString *avatarURL;
@property (nonatomic) NSString *linkedInID;
@property (nonatomic) NSString *entityID;

@end
