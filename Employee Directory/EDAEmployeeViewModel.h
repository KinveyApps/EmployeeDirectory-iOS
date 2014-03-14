//
//  EDAEmployeeModel.h
//  Employee Directory
//
//  Created by Justin Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EDAEmployee;

@interface EDAEmployeeViewModel : NSObject

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) NSString *titleAndGroup;
@property (nonatomic, readonly) NSString *linkedInHeadline;
@property (nonatomic, readonly) NSString *linkedInSummary;
@property (nonatomic, readonly) BOOL favorite;

/// Sends an EDAEmployee object whose username matches the supervisor property of employee.
@property (nonatomic, readonly) RACCommand *showSupervisorCommand;

/// Opens the employee's phone number in the phone app. Doesn't send anything.
@property (nonatomic, readonly) RACCommand *callCommand;

/// Sends the employee's phone number.
@property (nonatomic, readonly) RACCommand *textCommand;

/// Sends a tuple containing (recipients, subject, message).
@property (nonatomic, readonly) RACCommand *emailCommand;

/// Opens the employee's LinkedIn profile in Safari
@property (nonatomic, readonly) RACCommand *showLinkedInProfileCommand;

/// Sends an EDAEmployee object whose direct report should be shown
@property (nonatomic, readonly) RACCommand *showDirectReports;

/// Sends an EDAEmployee object who should be the recipient of a message
@property (nonatomic, readonly) RACCommand *messageCommand;

/// Sends an EDAFavorite object or nil
@property (nonatomic, readonly) RACCommand *favoriteCommand;

- (id)initWithEmployee:(EDAEmployee *)employee;

@end
