//
//  EDAEmployee.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EDAEmployee : NSObject <KCSPersistable>

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *division;
@property (nonatomic) NSString *department;
@property (nonatomic) NSString *group;
@property (nonatomic) NSString *workPhone;
@property (nonatomic) NSString *cellPhone;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *supervisor;
@property (nonatomic) NSString *hierarchy;
@property (nonatomic) NSString *entityID;

// LinkedIn
@property (nonatomic) NSString *headline;
@property (nonatomic) NSString *summary;
@property (nonatomic) NSString *avatarURL;
@property (nonatomic) NSString *linkedInID;

// For searching, don't use
@property (nonatomic) NSString *firstNameStandardized;
@property (nonatomic) NSString *lastNameStandardized;

@end
