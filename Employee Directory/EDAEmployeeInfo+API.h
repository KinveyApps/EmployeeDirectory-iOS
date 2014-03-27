//
//  EDAEmployeeInfo+API.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/27/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployeeInfo.h"

@interface EDAEmployeeInfo (API)

+ (KCSAppdataStore *)appdataStore;
+ (RACSignal *)infoForEmployeeWithID:(NSString *)employeeID;

/// @return A signal which sends the employee's avatar image.
- (RACSignal *)downloadAvatar;

/// @return A signal which sends the same object with update values
- (RACSignal *)update;

@end
