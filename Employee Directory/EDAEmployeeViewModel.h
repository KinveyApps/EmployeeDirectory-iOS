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

/// Sends an EDAEmployee object whose username matches the supervisor property of employee.
@property (nonatomic, readonly) RACCommand *showSupervisorCommand;

/// Opens the employee's phone number in the phone app. Doesn't send anything.
@property (nonatomic, readonly) RACCommand *callCommand;

/// Sends the employee's phone number.
@property (nonatomic, readonly) RACCommand *textCommand;

/// Sends a tuple containing (recipients, subject, message).
@property (nonatomic, readonly) RACCommand *emailCommand;

- (id)initWithEmployee:(EDAEmployee *)employee;

@end
