//
//  EDAGroup.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EDAGroup : NSObject <KCSPersistable>

@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *displayName;
@property (nonatomic) NSString *entityID;

@end
