//
//  EDAEmployeeModel.h
//  Employee Directory
//
//  Created by Justin Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EDATag.h"

@class EDAEmployee;

@interface EDAEmployeeViewModel : NSObject

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) NSString *titleAndGroup;
@property (nonatomic, readonly) NSString *linkedInHeadline;
@property (nonatomic, readonly) NSString *linkedInSummary;
@property (nonatomic, readonly) NSString *businessAddress;
@property (nonatomic, readonly) NSString *tagName;
@property (nonatomic, readonly) NSString *officePhone;
@property (nonatomic, readonly) NSString *mobilePhone;
@property (nonatomic, readonly) NSString *textPhone;
@property (nonatomic, readonly) NSString *email;

@property (nonatomic, readonly) BOOL favorite;

/// Sends an EDAEmployee object whose username matches the supervisor property of employee.
@property (nonatomic, readonly) RACCommand *showSupervisorCommand;

/// Opens the employee's phone number in the phone app. Doesn't send anything.
@property (nonatomic, readonly) RACCommand *callOfficeCommand;

/// Opens the employee's phone number in the phone app. Doesn't send anything.
@property (nonatomic, readonly) RACCommand *callMobileCommand;

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

/// Sends an tuple containing two arrays. The first array contains strings which should be used as the options in an action sheet. The second is numbers corresponding to the choices which should be passed to `tagWithType:`. The tuple also contains a number indicating the index of the "None" option in the array.
@property (nonatomic, readonly) RACCommand *tagCommand;

- (id)initWithEmployee:(EDAEmployee *)employee;

/// Tags the current employee with the given type
- (void)tagWithType:(EDATagType)type;

@end
