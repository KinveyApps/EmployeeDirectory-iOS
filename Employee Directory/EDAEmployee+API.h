//
//  EDAEmployee+API.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployee.h"

extern NSString * const EDAEmployeeErrorDomain;

extern NSInteger const EDAEmployeeErrorCodeUserNotFound;

@interface EDAEmployee (API)

+ (KCSAppdataStore *)appdataStore;

/// @return A signal which sends an array of all employees.
+ (RACSignal *)allEmployees;

/// @return A signal which sends an EDAEmployee object with the given username.
+ (RACSignal *)employeeWithUsername:(NSString *)username;

/// @return A signal which sends the employee's avatar image
- (RACSignal *)downloadAvatar;

@end
